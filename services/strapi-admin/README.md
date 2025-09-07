## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.5 |
| <a name="requirement_circleci"></a> [circleci](#requirement\_circleci) | 0.6.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_strapi_ecrs"></a> [strapi\_ecrs](#module\_strapi\_ecrs) | git@github.com:green-alchemist/terraform-modules.git//modules/ecr | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Profile | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | AWS Env | `string` | `"staging"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_registries"></a> [ecr\_registries](#output\_ecr\_registries) | ECR repositories created. |
