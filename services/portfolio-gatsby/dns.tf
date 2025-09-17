# --- STAGING DNS ---
# This block ONLY runs when create_apex_record is false.
module "subdomain_dns_record" {
  count  = var.create_apex_record ? 0 : 1
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

  zone_id       = data.aws_route53_zone.this.zone_id
  domain_name   = var.domain_name
  record_names  = [var.subdomain] # e.g., ["portfolio-staging"]

  alias_name    = module.cloudfront_static_site.domain_name
  alias_zone_id = module.cloudfront_static_site.hosted_zone_id
}

# --- PRODUCTION REDIRECTS & DNS ---
# These blocks ONLY run when create_apex_record is true.

# Create S3 bucket to redirect kconley.com -> portfolio.kconley.com
module "redirect_apex" {
  count  = var.create_apex_record ? 1 : 0
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"
  
  bucket_name              = var.domain_name
  redirect_target_hostname = local.hostname
  tags                     = var.tags
}

# Create S3 bucket to redirect www.kconley.com -> portfolio.kconley.com
module "redirect_www" {
  count  = var.create_apex_record ? 1 : 0
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"

  bucket_name              = "www.${var.domain_name}"
  redirect_target_hostname = local.hostname
  tags                     = var.tags
}

# Create the A record for the actual site (e.g., portfolio.kconley.com)
module "production_dns_record" {
  count  = var.create_apex_record ? 1 : 0
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

  zone_id       = data.aws_route53_zone.this.zone_id
  domain_name   = var.domain_name
  record_names  = [var.subdomain] # e.g., ["portfolio"]

  alias_name    = module.cloudfront_static_site.domain_name
  alias_zone_id = module.cloudfront_static_site.hosted_zone_id
}

# Create the A records for the redirects (@ and www)
module "redirect_dns_records" {
  count  = var.create_apex_record ? 1 : 0
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"

  zone_id       = data.aws_route53_zone.this.zone_id
  domain_name   = var.domain_name
  record_names  = ["@", "www"]

  # Note: Both records can point to the same S3 bucket endpoint for redirection.
  # AWS intelligently handles the request based on the Host header.
  alias_name    = module.redirect_apex[0].website_endpoint
  alias_zone_id = module.redirect_apex[0].hosted_zone_id
}