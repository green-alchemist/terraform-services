# ci/get-outputs.tf - This file is used by the CircleCI pipeline to fetch
# outputs from the portfolio-gatsby service's remote state.

terraform {
  # The backend configuration must match the service's state file location.
  backend "s3" {}
}

data "terraform_remote_state" "gatsby" {
  backend = "s3"
  config = {
    # These values will be passed via environment variables in the CI job
    bucket = var.tf_state_bucket
    key    = "portfolio-gatsby/staging/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket where the Terraform state is stored."
  type        = string
}

# Expose the outputs that the deployment script needs.
output "s3_bucket_name" {
  value = data.terraform_remote_state.gatsby.outputs.s3_bucket_name
}

output "cloudfront_distribution_id" {
  value = data.terraform_remote_state.gatsby.outputs.cloudfront_distribution_id
}
