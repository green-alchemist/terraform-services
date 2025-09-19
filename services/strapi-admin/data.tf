data "aws_ssm_parameter" "database_password" {
  name            = "/strapi/${var.environment}/env/DATABASE_PASSWORD"
  with_decryption = true
}