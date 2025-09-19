module "vpc" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/vpc"
}

module "public_subnet" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/public-subnet"
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source              = "git@github.com:green-alchemist/terraform-modules.git//modules/route-table"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
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
  source             = "git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway"
  name               = "strapi-admin-${var.environment}"
  subnet_ids         = [module.public_subnet.public_subnet_id]
  security_group_ids = [module.vpc_link_security_group.security_group_id]
  private_dns_name   = module.strapi_fargate.service_discovery_dns_name
  container_port     = 1337
}