variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "aws_profile" {
  description = "The AWS profile name to use for authentication."
  type        = string
  default     = "default"
}

variable "domain_name" {
  description = "The custom domain name for the website (e.g., my-portfolio.com)."
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the domain."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}