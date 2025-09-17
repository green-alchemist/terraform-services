data "aws_route53_zone" "this" {
  name = "kconley.com" # Your root domain
}

module "dns_record" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

  zone_id      = data.aws_route53_zone.this.zone_id
  domain_name  = "kconley.com"
  record_names = ["admin-${var.environment}"] # Creates "admin-staging" etc.

  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id
}