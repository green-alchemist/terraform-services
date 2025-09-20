data "aws_route53_zone" "this" {
  name = var.root_domain_name # Your root domain
}

module "dns_record" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

  zone_id      = data.aws_route53_zone.this.zone_id
  domain_name  = var.root_domain_name
  record_names = ["admin-${var.environment}"]

  # Point to the API Gateway's custom domain
  alias_zone_id            = module.api_gateway.api_gateway_hosted_zone_id # This will need to be updated to a custom domain
  alias_target_domain_name = module.api_gateway.api_gateway_target_domain_name
}