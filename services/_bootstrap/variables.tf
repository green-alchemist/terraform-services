variable "aws_region" {
  description = "The AWS region where the backend resources will be created."
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile to use for authentication."
  type        = string
}

variable "state_bucket_name" {
  description = "The globally unique name for the S3 bucket that will store Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "The name for the DynamoDB table used for state locking."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
