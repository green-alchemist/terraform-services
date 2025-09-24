# backend.tfvars for the staging environment of the strapi-admin service

bucket = "kc-portfolio-tf-state"
key    = "strapi-admin/staging/terraform.tfstate"
region = "us-east-1"
# use_lockfile = true  # Use native s3 lockfile
dynamodb_table = "kc-portfolio-tf-lock"
profile        = "default"
