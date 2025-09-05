# state.tf - Configures the remote S3 backend for Terraform state.

terraform {
  backend "s3" {}
}
