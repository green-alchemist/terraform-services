# backend.tfvars for the staging environment of the strapi-admin service

bucket         = "kc-portfolio-tf-state"
key            = "portfolio-gatsby/staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "kc-portfolio-tf-lock"
profile        = "default"
