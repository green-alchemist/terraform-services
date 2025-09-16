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

module "strapi_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"
  name   = "strapi-admin-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 1337
      to_port     = 1337
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
      security_groups = [module.strapi_security_group.security_group_id]
    }
  ]
}