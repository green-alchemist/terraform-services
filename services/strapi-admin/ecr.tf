module "strapi_ecr" {
  source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/ecr"
  ecrs = {
    strapi-admin-dev = {
      tags             = { Service = "strapi-admin-dev", Env = "dev" }
      # lifecycle_policy = local.lifecycle_policy
    },
    strapi-admin-prod = {
      tags             = { Service = "strapi-admin-prod", Env = "prod" }
    }
  }
  tags = {
    Terraform = "true"
  }

}

output "ecr_registries" {
  value = flatten([
    module.ecrs.names
  ])
  description = "ECR repositories created."
}