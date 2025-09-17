# Look up the hosted zone for your root domain
data "aws_route53_zone" "this" {
  name = var.domain_name
}

# Look up the existing, validated wildcard ACM certificate
data "aws_acm_certificate" "this" {
  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}