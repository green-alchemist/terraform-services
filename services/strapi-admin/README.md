## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.5 |
| <a name="requirement_circleci"></a> [circleci](#requirement\_circleci) | 0.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | git@github.com:green-alchemist/terraform-modules.git//modules/alb | n/a |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |
| <a name="module_aurora_db"></a> [aurora\_db](#module\_aurora\_db) | git@github.com:green-alchemist/terraform-modules.git//modules/aurora-serverless | n/a |
| <a name="module_aurora_security_group"></a> [aurora\_security\_group](#module\_aurora\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |
| <a name="module_dns_record"></a> [dns\_record](#module\_dns\_record) | git@github.com:green-alchemist/terraform-modules.git//modules/route53-record | n/a |
| <a name="module_ecs_task_execution_role"></a> [ecs\_task\_execution\_role](#module\_ecs\_task\_execution\_role) | git@github.com:green-alchemist/terraform-modules.git//modules/ecs-task-execution-role | n/a |
| <a name="module_internet_gateway"></a> [internet\_gateway](#module\_internet\_gateway) | git@github.com:green-alchemist/terraform-modules.git//modules/internet-gateway | n/a |
| <a name="module_public_subnet"></a> [public\_subnet](#module\_public\_subnet) | git@github.com:green-alchemist/terraform-modules.git//modules/public-subnet | n/a |
| <a name="module_route_table"></a> [route\_table](#module\_route\_table) | git@github.com:green-alchemist/terraform-modules.git//modules/route-table | n/a |
| <a name="module_strapi_ecrs"></a> [strapi\_ecrs](#module\_strapi\_ecrs) | git@github.com:green-alchemist/terraform-modules.git//modules/ecr | n/a |
| <a name="module_strapi_fargate"></a> [strapi\_fargate](#module\_strapi\_fargate) | git@github.com:green-alchemist/terraform-modules.git//modules/fargate | n/a |
| <a name="module_strapi_security_group"></a> [strapi\_security\_group](#module\_strapi\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git@github.com:green-alchemist/terraform-modules.git//modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Profile | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for the Strapi database. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | AWS Env | `string` | `"staging"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_url"></a> [admin\_url](#output\_admin\_url) | The URL of the Strapi admin panel. |
| <a name="output_ecr_registries"></a> [ecr\_registries](#output\_ecr\_registries) | ECR repositories created. |
