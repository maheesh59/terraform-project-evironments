resource "aws_secretsmanager_secret" "sonarqube_db" {
  name        = "${var.name}-database"
  description = "SonarQube PostgreSQL database credentials"

  tags = {
    Name    = "${var.name}-database"
    Service = "sonarqube"
  }
}

resource "aws_secretsmanager_secret_version" "sonarqube_db" {
  secret_id = aws_secretsmanager_secret.sonarqube_db.id

  secret_string = jsonencode({
    database = var.database_name
    username = var.database_username
    password = var.database_password
  })
}
