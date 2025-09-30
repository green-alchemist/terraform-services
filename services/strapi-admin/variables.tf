variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., staging, production) for the Strapi service."
  default     = "staging"
}

variable "root_domain_name" {
  type        = string
  description = "Root domain name for the API Gateway custom domain (e.g., example.com)."
}