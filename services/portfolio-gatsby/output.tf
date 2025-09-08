output "s3_bucket_name" {
  description = "The name of the S3 bucket where site files should be uploaded."
  value       = module.s3_site.bucket_id
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution for cache invalidation."
  value       = module.cloudfront.id
}

output "site_url" {
  description = "The final URL of the website."
  value       = "https://${var.subdomain}.${var.domain_name}"
}
