#!/bin/bash
set -euxo pipefail

dnf update -y

# Install SSM Agent
dnf install -y amazon-ssm-agent

# Enable and start SSM Agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install required packages
dnf install -y \
  java-21-amazon-corretto \
  fontconfig \
  wget \
  git \
  unzip \
  curl \
  docker

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Jenkins repository
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

# Install Jenkins
dnf install -y jenkins

# Allow Jenkins to use Docker
usermod -aG docker jenkins

# Start Jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

echo "Jenkins installation completed" > /var/log/platform-install.log
