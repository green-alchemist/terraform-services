# provider "circleci" {
#   api_token    = locals.envs["CIRCLECI_CLI_TOKEN"]
#   organization = locals.envs["CIRCLECI_ORGANIZATION"]
# }

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "aws_ssm_parameters_by_path" "env_var_names" {
  path       = "/strapi/${var.environment}/env/"
  depends_on = [module.env_parameter]
}

locals {
  ssm_env_vars = {
    for name, value in zipmap(data.aws_ssm_parameters_by_path.env_var_names.names, data.aws_ssm_parameters_by_path.env_var_names.values) :
    upper(basename(name)) => value
    if upper(basename(name)) != "DATABASE_PASSWORD"
  }
}



module "strapi_fargate" {
  source     = "git@github.com:green-alchemist/terraform-modules.git//modules/fargate"
  aws_region = var.aws_region
  depends_on = [module.aurora_db]

  cluster_name                = "strapi-admin-cluster"
  task_family                 = "strapi-admin-task"
  service_name                = "strapi-admin-service"
  container_name              = "strapi-admin"
  ecr_repository_url          = module.strapi_ecrs.urls["strapi-admin-${var.environment}"]
  ecs_task_execution_role_arn = module.ecs_roles.execution_role_arn
  task_role_arn               = module.ecs_roles.task_role_arn
  subnet_ids                  = module.private_subnets.subnet_ids
  security_group_ids          = [module.strapi_security_group.security_group_id]
  vpc_id                      = module.vpc.vpc_id
  assign_public_ip            = false
  enable_execute_command      = true
  # --- Enable Service Discovery ---
  enable_service_discovery               = true
  private_dns_namespace                  = "internal"
  service_discovery_health_check_enabled = false

  # --- Enable Scale-to-Zero ---
  enable_autoscaling            = true
  min_tasks                     = 1
  max_tasks                     = 1
  scale_down_evaluation_periods = 3

  environment_variables = merge(
    local.ssm_env_vars,
    {
      DATABASE_CLIENT   = "postgres"
      DATABASE_HOST     = module.aurora_db.cluster_endpoint
      DATABASE_PORT     = module.aurora_db.cluster_port
      DATABASE_NAME     = module.aurora_db.database_name
      DATABASE_USERNAME = module.aurora_db.master_username
    }
  )

  container_secrets = {
    DATABASE_PASSWORD = data.aws_ssm_parameter.database_password.arn
  }

  # Use the health check settings we discovered were necessary
  health_check_enabled      = true
  health_check_timeout      = 20
  health_check_start_period = 100
}



output "admin_url" {
  description = "The URL of the Strapi admin panel."
  value       = "http://admin-${var.environment}.${var.root_domain_name}"
}