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
| <a name="module_remote_state"></a> [remote\_state](#module\_remote\_state) | git@github.com:sigma-us/terraform-modules.git//modules/remote-state | n/a |
| <a name="module_strapi_ecrs"></a> [strapi\_ecrs](#module\_strapi\_ecrs) | git@github.com:sigma-us/terraform-modules.git//modules/ecr | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Profile | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | AWS Env | `string` | `"staging"` | no |
| <a name="input_remote_state_bucket_name"></a> [remote\_state\_bucket\_name](#input\_remote\_state\_bucket\_name) | S3 remote state bucket name | `string` | `"strapi-admin-tf-state"` | no |
| <a name="input_remote_state_dynamodb_table"></a> [remote\_state\_dynamodb\_table](#input\_remote\_state\_dynamodb\_table) | Remote State Lock DynamoDB Table name | `string` | `"strapi-admin-tf-lock"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_registries"></a> [ecr\_registries](#output\_ecr\_registries) | ECR repositories created. |
