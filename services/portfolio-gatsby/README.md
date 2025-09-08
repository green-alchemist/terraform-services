## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | git@github.com:green-alchemist/terraform-modules.git//modules/cloudfront | n/a |
| <a name="module_dns_records_portfolio"></a> [dns\_records\_portfolio](#module\_dns\_records\_portfolio) | git@github.com:green-alchemist/terraform-modules.git//modules/route53-record | n/a |
| <a name="module_dns_records_redirects"></a> [dns\_records\_redirects](#module\_dns\_records\_redirects) | git@github.com:green-alchemist/terraform-modules.git//modules/route53-record | n/a |
| <a name="module_redirect_apex"></a> [redirect\_apex](#module\_redirect\_apex) | git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect | n/a |
| <a name="module_redirect_www"></a> [redirect\_www](#module\_redirect\_www) | git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect | n/a |
| <a name="module_s3_site"></a> [s3\_site](#module\_s3\_site) | git@github.com:green-alchemist/terraform-modules.git//modules/s3-static-site | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | The ARN of the ACM certificate for the domain. Must cover the apex, www, and portfolio subdomains. | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile name to use for authentication. | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The apex domain name for the website (e.g., kconley.com). | `string` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain for the main portfolio site (e.g., 'portfolio'). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution for cache invalidation. |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the S3 bucket where site files should be uploaded. |
| <a name="output_site_url"></a> [site\_url](#output\_site\_url) | The final URL of the website. |
