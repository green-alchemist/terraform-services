module "aurora_db" {
  source                   = "git@github.com:green-alchemist/terraform-modules.git//modules/aurora-serverless"
  database_name            = "strapi"
  master_username          = "strapiadmin"
  master_password          = data.aws_ssm_parameter.database_password.value
  subnet_ids               = module.private_subnets.subnet_ids
  security_group_ids       = [module.aurora_security_group.security_group_id]
  seconds_until_auto_pause = 600
  max_capacity             = 1.0
  min_capacity             = 0.0
}
