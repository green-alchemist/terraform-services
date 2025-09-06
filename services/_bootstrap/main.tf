# This configuration creates the foundational S3 bucket and DynamoDB table
# that all other services will use for their remote state.

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "remote_state_bootstrap" {
  # Note: The source path is relative to this file's location
  source                  = "git@github.com:green-alchemist/terraform-modules.git//modules/remote-state"
  override_s3_bucket_name = true
  s3_bucket_name          = var.state_bucket_name
  dynamodb_table_name     = var.lock_table_name
  tags                    = var.tags
}





