data "aws_secretsmanager_secret" "db_password_secret" {
  name = "strapi/${var.environment}/database_password"
}

data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password_secret.id
}