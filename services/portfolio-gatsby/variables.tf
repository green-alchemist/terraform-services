variable "aws_profile" {
  description = "The AWS profile name to use for authentication."
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "domain_name" {
  description = "The apex domain name for the website (e.g., kconley.com)."
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the main portfolio site (e.g., 'portfolio')."
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the domain. Must cover the apex, www, and portfolio subdomains."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}


variable "create_apex_record" {
  description = "If true, creates records for the apex domain (@ and www). If false, creates a single record for the subdomain."
  type        = bool
  default     = false
}