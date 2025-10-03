# --- VPC, Subnets, and Core Networking ---
module "vpc" {
  source                   = "git@github.com:green-alchemist/terraform-modules.git//modules/vpc"
  vpc_enable_dns_hostnames = true
  vpc_enable_dns_support   = true
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
  source                     = "git@github.com:green-alchemist/terraform-modules.git//modules/route-tables"
  name_prefix                = "strapi-admin"
  vpc_id                     = module.vpc.vpc_id
  create_public_route_table  = true
  internet_gateway_id        = module.internet_gateway.internet_gateway_id
  public_subnets_map         = module.public_subnets.subnet_objects
  create_private_route_table = true
  private_subnets_map        = module.private_subnets.subnet_objects
}

# resource "aws_service_discovery_private_dns_namespace" "service_connect" {
#   name        = "strapi-internal"
#   description = "Private DNS namespace for Service Connect"
#   vpc         = module.vpc.vpc_id
# }

# --- Security Groups ---
module "strapi_security_group" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name        = "strapi-${var.environment}-fargate-sg"
  description = "Allows traffic from the VPC Link and allows all egress."
  vpc_id      = module.vpc.vpc_id

  # # This is a critical rule for VPC Link integrations. The VPC Link's network interfaces
  # # will be associated with this security group, and they need to be able to send traffic
  # # to the Fargate tasks, which are also in this security group.
  # ingress_rules = [{
  #   from_port   = module.strapi_fargate.container_port
  #   to_port     = module.strapi_fargate.container_port
  #   protocol    = "tcp"
  #   self        = true # Allows traffic from other resources in this same security group
  #   description = "Allow traffic from the API Gateway VPC Link"
  # }]
}

module "aurora_security_group" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name        = "strapi-${var.environment}-aurora-sg"
  description = "Security group for the Strapi Aurora database"
  vpc_id      = module.vpc.vpc_id
}

module "vpc_endpoint_security_group" {
  source      = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name        = "strapi-${var.environment}-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = module.vpc.vpc_id
}

# --- Security Group Rules ---
resource "aws_security_group_rule" "allow_fargate_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.aurora_security_group.security_group_id
  description              = "Allow Fargate to connect to the Aurora DB"
}

resource "aws_security_group_rule" "allow_fargate_to_endpoints" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.vpc_endpoint_security_group.security_group_id
  description              = "Allow Fargate to access VPC endpoints for AWS APIs"
}

resource "aws_security_group_rule" "vpc_link_to_fargate" {
  type                     = "ingress"
  from_port                = module.strapi_fargate.container_port
  to_port                  = module.strapi_fargate.container_port
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.strapi_security_group.security_group_id
  description              = "Allow VPC Link to Fargate tasks"
}

resource "aws_security_group_rule" "allow_fargate_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.strapi_security_group.security_group_id
  description       = "Allow all outbound traffic from Fargate"
}

# --- API Gateway with Module-Managed VPC Link ---
module "api_gateway" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway"

  name                = "strapi-admin-${var.environment}"
  domain_name         = "admin-${var.environment}.${var.root_domain_name}"
  acm_certificate_arn = data.aws_acm_certificate.this.arn

  # 1. Set the integration type to trigger the VPC Link creation inside the module.
  integration_type = "AWS_PROXY"

  # 2. Use the ARN of the service for the integration URI. API Gateway uses this to find the service.
  # integration_uri = module.strapi_fargate.service_discovery_arn
  integration_uri = module.strapi_fargate.service_discovery_arn # Not used in Lambda mode, but pass for modularity
  # 3. Pass the necessary subnet and security group IDs to the module.
  #    The module will use these to create its internal VPC Link.
  subnet_ids = module.private_subnets.subnet_ids
  # lambda_security_group_ids   = [module.]
  vpc_link_security_group_ids = [module.strapi_security_group.security_group_id]
  enable_access_logging       = true
  route_keys                  = ["ANY /{proxy+}"]
  throttling_burst_limit      = 10000
  throttling_rate_limit       = 5
  integration_timeout_millis  = 30000

  # 4. Enable Lambda proxy for scale-to-zero
  enable_lambda_proxy = true

  # 5. Pass ECS/Cloud Map vars for nested Lambda
  cluster_name              = module.strapi_fargate.cluster_name
  service_name              = module.strapi_fargate.service_name
  service_connect_namespace = module.strapi_fargate.service_discovery_namespace
  cloud_map_service_id      = module.strapi_fargate.service_discovery_id
  target_port               = module.strapi_fargate.container_port

  depends_on = [module.strapi_fargate]
}

# resource "aws_security_group_rule" "bastion_egress" {
#   security_group_id = var.bastion_sg_id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]  # For SSM
# }

# resource "aws_security_group_rule" "bastion_to_ecs" {
#   security_group_id        = var.bastion_sg_id
#   type                     = "egress"
#   from_port                = 1337
#   to_port                  = 1337
#   protocol                 = "tcp"
#   destination_security_group_id = var.ecs_sg_id  # ECS task SG
# }

# module "bastion" {
#   source                   = "git@github.com:green-alchemist/terraform-modules.git//modules/bastion-host"
#   service_name             = "strapi-admin"
#   public_subnet_id         = module.public_subnet_ids[0]  # From vpc module
#   bastion_security_group_id = module.security_groups.bastion_sg_id  # From SG module
# }