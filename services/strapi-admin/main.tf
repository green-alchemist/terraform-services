# provider "circleci" {
#   api_token    = locals.envs["CIRCLECI_CLI_TOKEN"]
#   organization = locals.envs["CIRCLECI_ORGANIZATION"]
# }

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "strapi_fargate" {
  source                      = "git@github.com:green-alchemist/terraform-modules.git//modules/fargate"
  cluster_name                = "strapi-admin-cluster"
  task_family                 = "strapi-admin-task"
  service_name                = "strapi-admin-service"
  container_name              = "strapi-admin"
  ecr_repository_url          = module.strapi_ecrs.urls["strapi-admin-${var.environment}"]
  ecs_task_execution_role_arn = module.ecs_task_execution_role.role_arn
  subnet_ids                  = [module.public_subnet.public_subnet_id]
  security_group_ids          = [module.strapi_security_group.security_group_id]
  enable_autoscaling          = true
  min_tasks                   = 0
  max_tasks                   = 1

  # Pass the load balancer configuration as a variable
  load_balancers = [
    {
      target_group_arn = module.alb.target_group_arn
      container_name   = "strapi-admin"
      container_port   = 1337
    }
  ]

  environment_variables = {
    DATABASE_CLIENT   = "postgres"
    DATABASE_HOST     = module.aurora_db.cluster_endpoint
    DATABASE_PORT     = module.aurora_db.cluster_port
    DATABASE_NAME     = module.aurora_db.database_name
    DATABASE_USERNAME = "strapiadmin"
    DATABASE_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["db_password"]
  }
}

output "admin_url" {
  description = "The URL of the Strapi admin panel."
  value       = "http://admin-${var.environment}.kconley.com"
}