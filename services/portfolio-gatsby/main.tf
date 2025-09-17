locals {
  # Construct the full hostname. If subdomain is empty (for production), it will just be the domain_name.
  hostname = var.subdomain == "" ? var.domain_name : "${var.subdomain}.${var.domain_name}"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "s3_site" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-static-site"
  # The bucket name is now the full hostname we want to serve
  bucket_name = local.hostname
  tags        = var.tags
}

module "cloudfront_static_site" {
  source                = "git@github.com:green-alchemist/terraform-modules.git//modules/cloudfront"
  s3_origin_domain_name = module.s3_site.website_endpoint
  s3_origin_id          = module.s3_site.bucket_id
  domain_name           = local.hostname
  domain_aliases        = var.create_apex_record ? ["www.${var.domain_name}"] : []
  
  # Use the ARN from the data source instead of a variable
  acm_certificate_arn   = data.aws_acm_certificate.this.arn 
  
  tags                  = var.tags
}




# # ------------------------------------------------------------------------------
# # REDIRECT INFRASTRUCTURE (kconley.com -> portfolio.kconley.com)
# # An S3 bucket configured to redirect the apex domain.
# # ------------------------------------------------------------------------------
# module "redirect_apex" {
#   source                   = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"
#   bucket_name              = var.domain_name
#   redirect_target_hostname = "${var.subdomain}.${var.domain_name}"
#   tags                     = var.tags
# }

# module "redirect_www" {
#   source                   = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-redirect"
#   bucket_name              = "www.${var.domain_name}"
#   redirect_target_hostname = "${var.subdomain}.${var.domain_name}"
#   tags                     = var.tags
# }

# # ------------------------------------------------------------------------------
# # DNS RECORDS
# # Creates all necessary Route 53 records.
# # ------------------------------------------------------------------------------
# module "dns_records_portfolio" {
#   source        = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"
#   zone_id       = data.aws_route53_zone.this.zone_id
#   domain_name   = var.domain_name
#   record_names  = [var.subdomain] # e.g., ["portfolio"]
#   alias_name    = module.cloudfront.domain_name
#   alias_zone_id = module.cloudfront.id
# }

# module "dns_records_redirects" {
#   source        = "git@github.com:green-alchemist/terraform-modules.git//modules/route53-record"
#   zone_id       = data.aws_route53_zone.this.zone_id
#   domain_name   = var.domain_name
#   record_names  = ["@", "www"]                          # The apex and www records
#   alias_name    = module.redirect_apex.website_endpoint # Both point to the same redirect endpoint logic
#   alias_zone_id = module.redirect_apex.hosted_zone_id
# }

