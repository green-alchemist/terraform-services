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
  default = "staging"
}

variable "aws_dynamodb_table" {
  description = "State lock table name"
}
