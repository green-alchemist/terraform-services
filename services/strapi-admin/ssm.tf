module "ecr_parameter" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/ssm-parameter"

  parameters = {
    "/strapi/${var.environment}/ecr-url" = {
      value       = module.strapi_ecrs.urls["strapi-admin-${var.environment}"]
      description = "The ECR repository URL for the Strapi Admin ${var.environment} environment."
      overwrite   = true
    }
    "/strapi/${var.environment}/ecs-cluster-name" = {
      value       = module.strapi_fargate.cluster_name
      description = "The ecs cluster name for the Strapi Admin ${var.environment} fargate."
      overwrite   = true
    }
    "/strapi/${var.environment}/ecs-service-name" = {
      value       = module.strapi_fargate.service_name
      description = "The ecs service name for the Strapi Admin ${var.environment} fargate."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/DATABASE_HOST" = {
      value       = module.aurora_db.cluster_endpoint
      description = "The database endpoint for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/DATABASE_USERNAME" = {
      value       = module.aurora_db.master_username
      description = "The database username for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/DATABASE_NAME" = {
      value       = module.aurora_db.database_name
      description = "The database endpoint for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/DATABASE_CLIENT" = {
      value       = "postgres"
      description = "The database client for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/NODE_ENV" = {
      value       = var.environment
      description = "The database endpoint for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/HOST" = {
      value       = "0.0.0.0"
      description = "The database endpoint for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
    "/strapi/${var.environment}/env/PORT" = {
      value       = "1337"
      description = "The database endpoint for the Strapi Admin ${var.environment} postgres."
      overwrite   = true
    }
  }

  tags = {
    Service     = "strapi-admin"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}