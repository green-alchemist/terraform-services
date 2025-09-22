module "vpc" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/vpc"
}

module "public_subnet" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/public-subnet"
  vpc_id = module.vpc.vpc_id
  public_subnets = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

module "internet_gateway" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source              = "git@github.com:green-alchemist/terraform-modules.git//modules/route-table"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  subnet_ids          = module.public_subnet.public_subnets_map
}

module "vpc_link_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name   = "strapi-admin-vpc-link-sg"
  vpc_id = module.vpc.vpc_id
  egress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    }
  ]
}

module "vpc_endpoint_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name   = "strapi-admin-endpoint-sg"
  vpc_id = module.vpc.vpc_id

  # Allow the main Strapi Fargate service to talk to the endpoints
  ingress_rules = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      security_groups = [module.strapi_security_group.security_group_id]
    }
  ]
}

module "strapi_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name   = "strapi-admin-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 1337
      to_port         = 1337
      protocol        = "tcp"
      cidr_blocks     = null
      security_groups = [module.vpc_link_security_group.security_group_id]
    }
  ]
}

module "aurora_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name   = "strapi-admin-db-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      cidr_blocks     = null
      security_groups = [module.strapi_security_group.security_group_id]
    }
  ]
}

# This is the corrected module block
module "api_gateway" {
  source              = "git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway"
  name                = "strapi-admin-${var.environment}"
  subnet_ids          = module.public_subnet.subnet_ids
  security_group_ids  = [module.vpc_link_security_group.security_group_id]
  private_dns_name    = module.strapi_fargate.service_discovery_dns_name
  container_port      = 1337
  fargate_service_arn = module.strapi_fargate.service_arn
  domain_name         = "admin-${var.environment}.${var.root_domain_name}"
  acm_certificate_arn = data.aws_acm_certificate.this.arn
  target_uri          = module.strapi_fargate.service_discovery_arn
  route_keys = [
    "ANY /admin/{proxy+}",
    "ANY /api/{proxy+}",
    "ANY /graphql"
  ]
}

# module "api_gateway" {
#   source  = "terraform-aws-modules/apigateway-v2/aws"
#   version = "~> 2.0" # It's good practice to pin to a major version

#   name          = "strapi-admin-${var.environment}"
#   description   = "HTTP API Gateway for Strapi Admin"
#   protocol_type = "HTTP"

#   # --- Domain and CORS ---
#   domain_name                 = "admin-${var.environment}.kconley.com"
#   domain_name_certificate_arn = data.aws_acm_certificate.this.arn # Make sure this data source exists in dns.tf

#   cors_configuration = {
#     allow_headers = ["*"]
#     allow_methods = ["*"]
#     allow_origins = ["*"]
#   }

#   # --- VPC Link ---
#   create_vpc_link              = true
#   disable_execute_api_endpoint = true # Important for private integrations
#   vpc_links = {
#     strapi-vpc = {
#       name               = "strapi-admin-${var.environment}-vpc-link"
#       security_group_ids = [module.vpc_link_security_group.security_group_id]
#       # Note: For production, these should be private subnets.
#       subnet_ids         = module.public_subnet.subnet_ids
#     }
#   }

#   # --- Routes and Integrations for Strapi ---
#   integrations = {
#     # Route for the Admin Panel
#     "ANY /admin/{proxy+}" = {
#       connection_type    = "VPC_LINK"
#       vpc_link           = "strapi-vpc"
#       integration_uri    = module.strapi_fargate.service_discovery_arn
#       integration_type   = "HTTP_PROXY"
#       integration_method = "ANY"
#     }
#     # Route for the Content API
#     "ANY /api/{proxy+}" = {
#       connection_type    = "VPC_LINK"
#       vpc_link           = "strapi-vpc"
#       integration_uri    = module.strapi_fargate.service_discovery_arn
#       integration_type   = "HTTP_PROXY"
#       integration_method = "ANY"
#     }
#     # Route for the GraphQL Plugin
#     "ANY /graphql" = {
#       connection_type    = "VPC_LINK"
#       vpc_link           = "strapi-vpc"
#       integration_uri    = module.strapi_fargate.service_discovery_arn
#       integration_type   = "HTTP_PROXY"
#       integration_method = "ANY"
#     }
#   }

#   tags = {
#     Service     = "strapi-admin"
#     Environment = var.environment
#   }
# }