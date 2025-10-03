# S3 Gateway Endpoint: Required for ECR to pull image layers, which are stored in S3.
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.route_tables.private_route_table_id]
  tags              = { Name = "strapi-admin-s3-endpoint" }
}

# CloudWatch Logs Interface Endpoint: For container logging to CloudWatch.
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-logs-endpoint" }
}

# Service Discovery Interface Endpoint: For ECS Service Connect registration.
resource "aws_vpc_endpoint" "servicediscovery" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.servicediscovery"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-servicediscovery-endpoint" }
}

# ECR API Interface Endpoint: For authenticating with the container registry.
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-ecr-api-endpoint" }
}

# ECR Docker Interface Endpoint: For pulling container image layers.
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "strapi-admin-ecr-dkr-endpoint" }
}

# STS Interface Endpoint: Required for the ECS agent to assume its IAM role.
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "${var.environment}-sts-endpoint" }
}

# # SSM Interface Endpoint: For fetching secrets from SSM Parameter Store.
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  tags                = { Name = "${var.environment}-ssm-endpoint" }
}

# # SSMMessages Interface Endpoint: Required for ECS Exec and the SSM agent.
# resource "aws_vpc_endpoint" "ssmmessages" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.private_subnets.subnet_ids
#   security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
#   tags                = { Name = "${var.environment}-ssmmessages-endpoint" }
# }

# # EC2Messages Interface Endpoint: Required by the SSM agent for session management (used by ECS Exec).
# resource "aws_vpc_endpoint" "ec2messages" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.private_subnets.subnet_ids
#   security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
#   tags                = { Name = "${var.environment}-ec2messages-endpoint" }
# }

resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.private_subnets.subnet_ids
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
}

# resource "aws_vpc_endpoint" "ecs_agent" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecs-agent"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.private_subnets.subnet_ids
#   security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
# }

# resource "aws_vpc_endpoint" "ecs_telemetry" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecs-telemetry"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.private_subnets.subnet_ids
#   security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
# }