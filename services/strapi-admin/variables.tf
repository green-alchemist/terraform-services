variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "environment" {
  description = "AWS Env"
  default     = "staging"
}

variable "remote_state_bucket_name" {
  description = "S3 remote state bucket name"
  default     = "strapi-admin-tf-state"
}

variable "remote_state_dynamodb_table" {
  description = "Remote State Lock DynamoDB Table name"
  default     = "strapi-admin-tf-lock"
}
