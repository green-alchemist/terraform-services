resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.route_table.route_table_id]
  tags              = { Name = "strapi-admin-s3-endpoint" }
}

# Endpoint for CloudWatch Logs (Interface Type) - For container logging.
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.public_subnet.subnet_ids # Using public subnets as defined in your networking.tf
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-logs-endpoint" }
}

# Endpoint for ECR API (Interface Type) - For Docker authentication.
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.public_subnet.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-ecr-api-endpoint" }
}

# Endpoint for ECR Docker Registry (Interface Type) - For pulling image layers.
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.public_subnet.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-ecr-dkr-endpoint" }
}