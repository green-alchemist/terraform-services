provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# ------------------------------------------------------------------------------
# S3 Bucket for Static Site Hosting
# ------------------------------------------------------------------------------
module "s3_site" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/s3-static-site"
  bucket_name = var.domain_name
  tags        = var.tags
}

# ------------------------------------------------------------------------------
# CloudFront Distribution for CDN
# ------------------------------------------------------------------------------
module "cloudfront_static_site" {
  source                = "git@github.com:green-alchemist/terraform-modules.git//modules/cloudfront"
  s3_origin_domain_name      = module.s3_site.website_endpoint
  s3_origin_id               = module.s3_site.bucket_id
  domain_name                = var.domain_name
  acm_certificate_arn        = var.acm_certificate_arn
  tags                       = var.tags
  route53_zone_id            = data.aws_route53_zone.this.zone_id
}

# ------------------------------------------------------------------------------
# Route 53 DNS Records
# ------------------------------------------------------------------------------
data "aws_route53_zone" "this" {
  name = var.domain_name
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "www.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = module.cloudfront_static_site.cloudfront_distribution_domain_name
#     zone_id                = module.cloudfront_static_site.cloudfront_distribution_hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route5s3_record" "apex" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = module.cloudfront_static_site.cloudfront_distribution_domain_name
#     zone_id                = module.cloudfront_static_site.cloudfront_distribution_hosted_zone_id
#     evaluate_target_health = false
#   }
# }

