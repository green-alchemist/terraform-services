## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway | n/a |
| <a name="module_aurora_db"></a> [aurora\_db](#module\_aurora\_db) | git@github.com:green-alchemist/terraform-modules.git//modules/aurora-serverless | n/a |
| <a name="module_aurora_security_group"></a> [aurora\_security\_group](#module\_aurora\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |
| <a name="module_dns_record"></a> [dns\_record](#module\_dns\_record) | git@github.com:green-alchemist/terraform-modules.git//modules/route53-record | n/a |
| <a name="module_ecr_parameter"></a> [ecr\_parameter](#module\_ecr\_parameter) | git@github.com:green-alchemist/terraform-modules.git//modules/ssm-parameter | n/a |
| <a name="module_ecs_roles"></a> [ecs\_roles](#module\_ecs\_roles) | git@github.com:green-alchemist/terraform-modules.git//modules/ecs-task-execution-role | n/a |
| <a name="module_env_parameter"></a> [env\_parameter](#module\_env\_parameter) | git@github.com:green-alchemist/terraform-modules.git//modules/ssm-parameter | n/a |
| <a name="module_internet_gateway"></a> [internet\_gateway](#module\_internet\_gateway) | git@github.com:green-alchemist/terraform-modules.git//modules/internet-gateway | n/a |
| <a name="module_private_subnets"></a> [private\_subnets](#module\_private\_subnets) | git@github.com:green-alchemist/terraform-modules.git//modules/subnets | n/a |
| <a name="module_public_subnets"></a> [public\_subnets](#module\_public\_subnets) | git@github.com:green-alchemist/terraform-modules.git//modules/subnets | n/a |
| <a name="module_route_tables"></a> [route\_tables](#module\_route\_tables) | git@github.com:green-alchemist/terraform-modules.git//modules/route-tables | n/a |
| <a name="module_strapi_ecrs"></a> [strapi\_ecrs](#module\_strapi\_ecrs) | git@github.com:green-alchemist/terraform-modules.git//modules/ecr | n/a |
| <a name="module_strapi_fargate"></a> [strapi\_fargate](#module\_strapi\_fargate) | git@github.com:green-alchemist/terraform-modules.git//modules/fargate | n/a |
| <a name="module_strapi_lambda_proxy"></a> [strapi\_lambda\_proxy](#module\_strapi\_lambda\_proxy) | git@github.com:green-alchemist/terraform-modules.git//modules/lambda-proxy | n/a |
| <a name="module_strapi_security_group"></a> [strapi\_security\_group](#module\_strapi\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git@github.com:green-alchemist/terraform-modules.git//modules/vpc | n/a |
| <a name="module_vpc_endpoint_security_group"></a> [vpc\_endpoint\_security\_group](#module\_vpc\_endpoint\_security\_group) | git@github.com:green-alchemist/terraform-modules.git//modules/security-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_permission.api_gateway_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group_rule.allow_fargate_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_fargate_to_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_fargate_to_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_lambda_to_fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_lambda_to_vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lambda_egress_to_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lambda_egress_to_fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_service_discovery_private_dns_namespace.service_connect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_vpc_endpoint.ec2messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.servicediscovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_proxy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.strapi_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.database_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameters_by_path.env_var_names](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameters_by_path) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Profile | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | AWS Env | `string` | `"staging"` | no |
| <a name="input_root_domain_name"></a> [root\_domain\_name](#input\_root\_domain\_name) | base domain | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_url"></a> [admin\_url](#output\_admin\_url) | The URL of the Strapi admin panel. |
| <a name="output_ecr_registries"></a> [ecr\_registries](#output\_ecr\_registries) | ECR repositories created. |
