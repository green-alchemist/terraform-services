data "aws_ssm_parameter" "database_password" {
  name            = "/strapi/${var.environment}/env/DATABASE_PASSWORD"
  with_decryption = true
}

data "aws_acm_certificate" "this" {
  domain      = "*.${var.root_domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}
