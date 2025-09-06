aws_region        = "us-east-1"
aws_profile       = "default"
state_bucket_name = "kc-portfolio-tf-state" # MUST be globally unique
lock_table_name   = "kc-portfolio-tf-lock"
tags = {
  Project = "Portfolio-resources"
}