module "vpc" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/vpc"
}

module "public_subnets" {
  source                     = "git@github.com:green-alchemist/terraform-modules.git//modules/subnets"
  vpc_id                     = module.vpc.vpc_id
  name_prefix                = "public"
  assign_public_ip_on_launch = true

  subnets = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

module "private_subnets" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/subnets"
  vpc_id      = module.vpc.vpc_id
  name_prefix = "private"

  subnets = {
    "us-east-1a" = "10.0.101.0/24"
    "us-east-1b" = "10.0.102.0/24"
  }
}


module "internet_gateway" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_tables" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/route-tables"
  name_prefix = "strapi-admin"
  vpc_id      = module.vpc.vpc_id

  # Public Route Table configuration
  create_public_route_table = true
  internet_gateway_id       = module.internet_gateway.internet_gateway_id
  public_subnets_map        = module.public_subnets.subnet_objects

  # Private Route Table configuration
  create_private_route_table = true
  private_subnets_map        = module.private_subnets.subnet_objects
}

# --- Security Groups (Defined as empty containers first) ---

module "strapi_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"

  name        = "strapi-${var.environment}-fargate-sg"
  description = "Security group for the Strapi Fargate service"
  vpc_id      = module.vpc.vpc_id
}

# Security group for the Aurora database
module "aurora_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"

  name        = "strapi-${var.environment}-aurora-sg"
  description = "Security group for the Strapi Aurora database"
  vpc_id      = module.vpc.vpc_id
}

# Security group for the API Gateway VPC Link
module "vpc_link_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"

  name        = "strapi-${var.environment}-vpclink-sg"
  description = "Security group for the API Gateway VPC Link"
  vpc_id      = module.vpc.vpc_id
}

# Security group for the VPC Interface Endpoints
module "vpc_endpoint_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"

  name        = "strapi-${var.environment}-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "allow_apigw_to_fargate" {
  type                     = "ingress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  source_security_group_id = module.vpc_link_security_group.security_group_id
  security_group_id        = module.strapi_security_group.security_group_id
}

# Rule: Allow Fargate to talk to the Database
resource "aws_security_group_rule" "allow_fargate_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.aurora_security_group.security_group_id
}

# Rule: Allow Fargate to talk to the VPC Endpoints
resource "aws_security_group_rule" "allow_fargate_to_endpoints" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.vpc_endpoint_security_group.security_group_id
}

# Rule: Allow Fargate to talk outbound to the internet (for VPC Endpoints, etc.)
# resource "aws_security_group_rule" "allow_fargate_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.strapi_security_group.security_group_id
# }
resource "aws_security_group_rule" "allow_all_fargate_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # "-1" means all protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.strapi_security_group.security_group_id
}


# This is the corrected module block
module "api_gateway" {
  source                = "git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway"
  name                  = "strapi-admin-${var.environment}"
  subnet_ids            = module.private_subnets.subnet_ids
  security_group_ids    = [module.vpc_link_security_group.security_group_id]
  fargate_service_arn   = module.strapi_fargate.service_arn
  domain_name           = "admin-${var.environment}.${var.root_domain_name}"
  acm_certificate_arn   = data.aws_acm_certificate.this.arn
  target_uri            = module.strapi_fargate.service_discovery_arn
  enable_access_logging = true
  route_keys = [
    "ANY /",
    "ANY /admin/{proxy+}",
    "ANY /api/{proxy+}",
    "ANY /graphql"
  ]
}
