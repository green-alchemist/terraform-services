# data "aws_ssm_parameter" "db_password" {
#   name            = "/strapi/${var.environment}/db_password"
#   with_decryption = true
# }