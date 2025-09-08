provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# ------------------------------------------------------------------------------
# DATA SOURCES
# Look up information about the existing Route 53 Hosted Zone.
# ------------------------------------------------------------------------------
data "aws_route53_zone" "this" {
  name = var.domain_name
}

# Look up the existing, validated ACM certificate for the domain.
data "aws_acm_certificate" "this" {
  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

# ------------------------------------------------------------------------------
# PORTFOLIO SITE INFRASTRUCTURE (portfolio.kconley.com)
# The core S3 bucket and CloudFront distribution for the actual Gatsby site.
# ------------------------------------------------------------------------------
module "s3_site" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-static-site"
  bucket_name = "${var.subdomain}.${var.domain_name}"
  tags        = var.tags
}

module "cloudfront" {
  source                = "git@github.com:green-alchemist/terraform-modules.git//modules/cloudfront"
  s3_origin_domain_name = module.s3_site.website_endpoint
  s3_origin_id          = module.s3_site.bucket_id
  domain_name           = var.domain_name
  # CloudFront needs aliases for all domains it will serve traffic for.
  domain_aliases        = ["${var.subdomain}.${var.domain_name}"]
  acm_certificate_arn   = data.aws_acm_certificate.this.arn
  tags                  = var.tags
}

# ------------------------------------------------------------------------------
# REDIRECT INFRASTRUCTURE (kconley.com -> portfolio.kconley.com)
# An S3 bucket configured to redirect the apex domain.
# ------------------------------------------------------------------------------
module "redirect_apex" {
  source          = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"
  bucket_name     = var.domain_name
  redirect_target_hostname = "${var.subdomain}.${var.domain_name}"
  tags            = var.tags
}

module "redirect_www" {
  source          = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"
  bucket_name     = "www.${var.domain_name}"
  redirect_target_hostname = "${var.subdomain}.${var.domain_name}"
  tags            = var.tags
}

# ------------------------------------------------------------------------------
# DNS RECORDS
# Creates all necessary Route 53 records.
# ------------------------------------------------------------------------------
module "dns_records_portfolio" {
  source        = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"
  zone_id       = data.aws_route53_zone.this.zone_id
  domain_name   = var.domain_name
  record_names  = [var.subdomain] # e.g., ["portfolio"]
  alias_name    = module.cloudfront.domain_name
  alias_zone_id = module.cloudfront.id
}

module "dns_records_redirects" {
  source        = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"
  zone_id       = data.aws_route53_zone.this.zone_id
  domain_name   = var.domain_name
  record_names  = ["@", "www"] # The apex and www records
  alias_name    = module.redirect_apex.website_endpoint # Both point to the same redirect endpoint logic
  alias_zone_id = module.redirect_apex.hosted_zone_id
}

