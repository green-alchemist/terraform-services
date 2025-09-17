module "strapi_ecrs" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/ecr"

  ecrs = {
    "strapi-admin-${var.environment}" = {
      tags = {
        Service     = "strapi-admin"
        Environment = var.environment
      }
    }
  }

  tags = {
    Terraform = "true"
  }
}

output "ecr_registries" {
  value       = module.strapi_ecrs.names
  description = "ECR repositories created."
}