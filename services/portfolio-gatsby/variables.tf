variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "domain_name" {
  description = "The custom domain name for the website (e.g., example.com)."
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the domain."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}

