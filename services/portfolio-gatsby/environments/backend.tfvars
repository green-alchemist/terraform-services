# backend.tfvars - Staging backend configuration for the Gatsby service

bucket         = "your-terraform-state-bucket-name" # The S3 bucket where you store your Terraform state
key            = "portfolio-gatsby/staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "your-terraform-lock-table-name"
