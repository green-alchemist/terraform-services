provider "aws" {
  region = var.aws_region
}

module "s3_site" {
  source      = "../../terraform-modules/modules/s3-static-site"
  bucket_name = var.domain_name
  tags        = var.tags
}

module "cloudfront" {
  source                     = "../../terraform-modules/modules/cloudfront-static-site"
  s3_bucket_website_endpoint = module.s3_site.bucket_website_endpoint
  bucket_name                = module.s3_site.bucket_name
  domain_aliases             = [var.domain_name]
  acm_certificate_arn        = var.acm_certificate_arn
  tags                       = var.tags
}

