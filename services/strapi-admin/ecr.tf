module "strapi_ecrs" {
  source = "git@github.com:sigma-us/terraform-modules.git//modules/ecr"
  ecrs = {
    strapi-admin-dev = {
      tags = { Service = "strapi-admin-dev", Env = "dev" }
      # lifecycle_policy = local.lifecycle_policy
    },
    strapi-admin-prod = {
      tags = { Service = "strapi-admin-prod", Env = "prod" }
    }
  }
  tags = {
    Terraform = "true"
  }

}

output "ecr_registries" {
  value = flatten([
    module.strapi_ecrs.names
  ])
  description = "ECR repositories created."
}