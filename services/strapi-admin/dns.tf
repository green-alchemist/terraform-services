data "aws_route53_zone" "this" {
  name = "kconley.com" # Your root domain
}

# module "dns_record" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

#   zone_id      = data.aws_route53_zone.this.zone_id
#   domain_name  = "kconley.com"
#   record_names = ["admin-${var.environment}"]

#   # Point to the API Gateway's custom domain
#   alias_name    = module.api_gateway.api_endpoint # This will need to be updated to a custom domain
#   alias_zone_id = module.api_gateway.api_id       # This will need to be updated to a custom domain
# }