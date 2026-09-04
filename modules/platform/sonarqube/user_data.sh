#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/sonarqube-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=================================================="
echo "Starting SonarQube installation"
echo "=================================================="

AWS_REGION="${aws_region}"
DB_SECRET_ARN="${secret_arn}"
SONARQUBE_VERSION="${sonarqube_version}"
JAVA_VERSION="${java_version}"

SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$${SONARQUBE_VERSION}.zip"

echo "AWS Region       : $${AWS_REGION}"
echo "SonarQube version: $${SONARQUBE_VERSION}"
echo "Java version     : $${JAVA_VERSION}"

# ==================================================
# SYSTEM UPDATE
# ==================================================

echo "Updating operating system..."

dnf update -y

# ==================================================
# INSTALL COMMON PACKAGES
# ==================================================

echo "Installing required packages..."

dnf install -y \
  wget \
  unzip \
  jq \
  openssl \
  awscli \
  amazon-ssm-agent \
  curl \
  tar \
  gzip

# ==================================================
# INSTALL JAVA
# ==================================================

echo "Installing Java $${JAVA_VERSION}..."

case "$${JAVA_VERSION}" in
  17)
    dnf install -y java-17-amazon-corretto
    ;;
  21)
    dnf install -y java-21-amazon-corretto
    ;;
  *)
    echo "ERROR: Unsupported Java version: $${JAVA_VERSION}"
    exit 1
    ;;
esac

echo "Java installation completed."

java -version

# ==================================================
# START SSM
# ==================================================

echo "Starting SSM Agent..."

systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# ==================================================
# KERNEL SETTINGS
# ==================================================

echo "Configuring kernel parameters..."

cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

# ==================================================
# INSTALL POSTGRESQL
# ==================================================

echo "Installing PostgreSQL..."

dnf install -y \
  postgresql16 \
  postgresql16-server \
  postgresql16-contrib

# ==================================================
# INITIALIZE POSTGRESQL
# ==================================================

echo "Initializing PostgreSQL..."

if [ ! -f /var/lib/pgsql/data/PG_VERSION ]; then

  if command -v postgresql-setup >/dev/null 2>&1; then
    postgresql-setup --initdb
  elif command -v postgresql-16-setup >/dev/null 2>&1; then
    postgresql-16-setup initdb
  else
    echo "ERROR: PostgreSQL initialization command not found."
    exit 1
  fi

else

  echo "PostgreSQL is already initialized."

fi

# ==================================================
# FIND POSTGRES SERVICE
# ==================================================

if systemctl list-unit-files | grep -q "^postgresql.service"; then
  POSTGRES_SERVICE="postgresql"
elif systemctl list-unit-files | grep -q "^postgresql-16.service"; then
  POSTGRES_SERVICE="postgresql-16"
else
  echo "ERROR: PostgreSQL service not found."
  exit 1
fi

echo "PostgreSQL service: $${POSTGRES_SERVICE}"

# ==================================================
# START POSTGRESQL
# ==================================================

systemctl enable "$${POSTGRES_SERVICE}"
systemctl start "$${POSTGRES_SERVICE}"

sleep 10

systemctl is-active "$${POSTGRES_SERVICE}"

# ==================================================
# GET DATABASE SECRET
# ==================================================

echo "Retrieving database credentials from Secrets Manager..."

SECRET_JSON="$(aws secretsmanager get-secret-value \
  --secret-id "$${DB_SECRET_ARN}" \
  --region "$${AWS_REGION}" \
  --query SecretString \
  --output text)"

if [ -z "$${SECRET_JSON}" ] || [ "$${SECRET_JSON}" = "None" ]; then
  echo "ERROR: Failed to retrieve database secret."
  exit 1
fi

DB_NAME="$(echo "$${SECRET_JSON}" | jq -r '.database')"
DB_USER="$(echo "$${SECRET_JSON}" | jq -r '.username')"
DB_PASSWORD="$(echo "$${SECRET_JSON}" | jq -r '.password')"

if [ -z "$${DB_NAME}" ] || [ "$${DB_NAME}" = "null" ]; then
  echo "ERROR: Database name is missing."
  exit 1
fi

if [ -z "$${DB_USER}" ] || [ "$${DB_USER}" = "null" ]; then
  echo "ERROR: Database username is missing."
  exit 1
fi

if [ -z "$${DB_PASSWORD}" ] || [ "$${DB_PASSWORD}" = "null" ]; then
  echo "ERROR: Database password is missing."
  exit 1
fi

echo "Database name: $${DB_NAME}"
echo "Database user: $${DB_USER}"

# ==================================================
# CREATE DATABASE USER
# ==================================================

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$${DB_USER}'" | grep -q 1; then

  echo "Database user already exists."

  sudo -u postgres psql <<EOF
ALTER USER "$${DB_USER}" WITH PASSWORD '$${DB_PASSWORD}';
EOF

else

  echo "Creating database user..."

  sudo -u postgres psql <<EOF
CREATE USER "$${DB_USER}" WITH PASSWORD '$${DB_PASSWORD}';
EOF

fi

# ==================================================
# CREATE DATABASE
# ==================================================

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$${DB_NAME}'" | grep -q 1; then

  echo "Database already exists."

else

  echo "Creating database..."

  sudo -u postgres psql <<EOF
CREATE DATABASE "$${DB_NAME}"
OWNER "$${DB_USER}"
ENCODING 'UTF8';
EOF

fi

# ==================================================
# TEST DATABASE
# ==================================================

echo "Testing PostgreSQL authentication..."

PGPASSWORD="$${DB_PASSWORD}" psql \
  -h 127.0.0.1 \
  -p 5432 \
  -U "$${DB_USER}" \
  -d "$${DB_NAME}" \
  -c "SELECT current_database(), current_user;"

echo "PostgreSQL authentication successful."

# ==================================================
# CREATE SONARQUBE USER
# ==================================================

if ! id sonarqube >/dev/null 2>&1; then

  useradd \
    --system \
    --home-dir /opt/sonarqube \
    --shell /sbin/nologin \
    sonarqube

fi

# ==================================================
# CREATE DIRECTORIES
# ==================================================

mkdir -p /var/sonarqube/data
mkdir -p /var/sonarqube/temp

chown -R sonarqube:sonarqube /var/sonarqube

# ==================================================
# DOWNLOAD SONARQUBE
# ==================================================

echo "Downloading SonarQube $${SONARQUBE_VERSION}..."

cd /opt

rm -f /opt/sonarqube.zip

wget \
  --https-only \
  --timeout=60 \
  --tries=3 \
  -O /opt/sonarqube.zip \
  "$${SONARQUBE_URL}"

if [ ! -s /opt/sonarqube.zip ]; then
  echo "ERROR: SonarQube download failed."
  exit 1
fi

# ==================================================
# EXTRACT
# ==================================================

echo "Extracting SonarQube..."

rm -rf /opt/sonarqube-install

mkdir -p /opt/sonarqube-install

unzip -q /opt/sonarqube.zip \
  -d /opt/sonarqube-install

SONAR_DIR="$(find /opt/sonarqube-install \
  -maxdepth 1 \
  -mindepth 1 \
  -type d \
  -name "sonarqube-*" \
  | head -n 1)"

if [ -z "$${SONAR_DIR}" ]; then
  echo "ERROR: SonarQube directory was not found."
  exit 1
fi

rm -rf /opt/sonarqube

mv "$${SONAR_DIR}" /opt/sonarqube

rm -rf /opt/sonarqube-install
rm -f /opt/sonarqube.zip

chown -R sonarqube:sonarqube /opt/sonarqube

# ==================================================
# SONARQUBE CONFIGURATION
# ==================================================

echo "Configuring SonarQube..."

cat > /opt/sonarqube/conf/sonar.properties <<EOF
sonar.jdbc.username=$${DB_USER}
sonar.jdbc.password=$${DB_PASSWORD}
sonar.jdbc.url=jdbc:postgresql://127.0.0.1:5432/$${DB_NAME}

sonar.web.host=0.0.0.0
sonar.web.port=9000

sonar.path.data=/var/sonarqube/data
sonar.path.temp=/var/sonarqube/temp
EOF

chown sonarqube:sonarqube \
  /opt/sonarqube/conf/sonar.properties

chmod 640 \
  /opt/sonarqube/conf/sonar.properties

# ==================================================
# SYSTEM LIMITS
# ==================================================

cat > /etc/security/limits.d/99-sonarqube.conf <<EOF
sonarqube soft nofile 65536
sonarqube hard nofile 65536

sonarqube soft nproc 4096
sonarqube hard nproc 4096
EOF

# ==================================================
# SYSTEMD SERVICE
# ==================================================

cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube Server
After=network-online.target $${POSTGRES_SERVICE}.service
Wants=network-online.target
Requires=$${POSTGRES_SERVICE}.service

[Service]
Type=forking

User=sonarqube
Group=sonarqube

WorkingDirectory=/opt/sonarqube

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=on-failure
RestartSec=10

LimitNOFILE=65536
LimitNPROC=4096

TimeoutStartSec=600
TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
EOF

# ==================================================
# ENABLE AND START
# ==================================================

systemctl daemon-reload

systemctl enable sonarqube

echo "Starting SonarQube..."

systemctl start sonarqube

# ==================================================
# WAIT FOR SONARQUBE
# ==================================================

SONARQUBE_READY=false

for i in {1..60}; do

  if curl -sf \
    http://127.0.0.1:9000/api/system/status \
    >/dev/null 2>&1; then

    SONARQUBE_READY=true

    echo "SonarQube is responding."

    break

  fi

  echo "Waiting for SonarQube... $${i}/60"

  sleep 10

done

# ==================================================
# STATUS
# ==================================================

systemctl status sonarqube --no-pager || true

systemctl status "$${POSTGRES_SERVICE}" --no-pager || true

ss -lntp || true

# ==================================================
# FINAL CHECK
# ==================================================

if [ "$${SONARQUBE_READY}" = true ]; then

  echo "=================================================="
  echo "SonarQube installation completed successfully."
  echo "Port: 9000"
  echo "=================================================="

else

  echo "=================================================="
  echo "ERROR: SonarQube did not become ready."
  echo "=================================================="

  journalctl -u sonarqube \
    --no-pager \
    -n 100 || true

  ls -la /opt/sonarqube/logs/ || true

  exit 1

fi

unset DB_PASSWORD
unset SECRET_JSON

echo "=================================================="
echo "SonarQube bootstrap completed."
echo "=================================================="
