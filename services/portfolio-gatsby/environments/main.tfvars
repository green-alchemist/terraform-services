# main.tfvars - Staging environment variables for the Gatsby service

aws_region          = "us-east-1"
domain_name         = "your-domain.com"                                             # e.g., kconley.com
s3_bucket_name      = "your-unique-bucket-name-staging"                             # Must be globally unique
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/your-cert-id" # Replace with your ACM cert ARN for the domain
tags = {
  Project     = "Aether-Portfolio"
  Environment = "Staging"
  ManagedBy   = "Terraform"
}
