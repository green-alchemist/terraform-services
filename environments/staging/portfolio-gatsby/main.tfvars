# main.tfvars - Staging environment variables for the Gatsby service

aws_region          = "us-east-1"
domain_name         = "kconley.com"
subdomain           = "staging"
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/your-cert-id" # Replace with your ACM cert ARN

tags = {
  Project     = "Aether-Portfolio"
  Environment = "Staging"
  ManagedBy   = "Terraform"
}
