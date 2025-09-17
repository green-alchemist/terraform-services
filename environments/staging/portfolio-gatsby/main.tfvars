aws_region  = "us-east-1"
aws_profile = "default"
domain_name = "kconley.com"

# --- Environment-Specific Variables ---
subdomain          = "portfolio-staging"
create_apex_record = true

tags = {
  Project     = "Aether-Portfolio"
  Environment = "staging"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
}