module "aurora_db" {
  source             = "git@github.com:green-alchemist/terraform-modules.git//modules/aurora-serverless"
  database_name      = "strapi"
  master_username    = "strapiadmin"
  master_password    = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]
  subnet_ids         = [module.public_subnet.public_subnet_id]
  security_group_ids = [module.aurora_security_group.security_group_id]
}