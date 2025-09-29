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

resource "aws_service_discovery_private_dns_namespace" "service_connect" {
  name        = "strapi-internal"
  description = "Private DNS namespace for Service Connect"
  vpc         = module.vpc.vpc_id
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

# Security group for the VPC Interface Endpoints
module "vpc_endpoint_security_group" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/security-group"

  name        = "strapi-${var.environment}-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = module.vpc.vpc_id
}

# --- Ingress Rules ---

# Rule: Allow Lambda to talk to the Fargate service on the application port.
resource "aws_security_group_rule" "allow_lambda_to_fargate" {
  type                     = "ingress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  source_security_group_id = module.strapi_lambda_proxy.lambda_security_group_id
  security_group_id        = module.strapi_security_group.security_group_id
}

# Rule: Allow Lambda to talk to Fargate service.
resource "aws_security_group_rule" "lambda_egress_to_fargate" {
  type                     = "egress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.strapi_lambda_proxy.lambda_security_group_id
  description              = "Allow Lambda to connect to the Strapi Fargate service"
}

# Rule: Allow Fargate to talk to the Database.
resource "aws_security_group_rule" "allow_fargate_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.aurora_security_group.security_group_id
}

# Rule: Allow Fargate to talk to the VPC Endpoints for AWS APIs.
resource "aws_security_group_rule" "allow_fargate_to_endpoints" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.strapi_security_group.security_group_id
  security_group_id        = module.vpc_endpoint_security_group.security_group_id
}

# Rule: Allow Lambda to talk to the VPC Endpoints for AWS APIs.
resource "aws_security_group_rule" "allow_lambda_to_vpc_endpoints" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.strapi_lambda_proxy.lambda_security_group_id
  security_group_id        = module.vpc_endpoint_security_group.security_group_id
}

# Rule: Allow Lambda to connect to VPC Endpoints.
resource "aws_security_group_rule" "lambda_egress_to_endpoints" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.vpc_endpoint_security_group.security_group_id
  security_group_id        = module.strapi_lambda_proxy.lambda_security_group_id
  description              = "Allow Lambda to connect to AWS services via VPC endpoints"
}



# --- Egress Rules ---

# Rule: Allow Fargate to talk outbound to the internet (for VPC Endpoints, etc.).
resource "aws_security_group_rule" "allow_fargate_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.strapi_security_group.security_group_id
}




# This is the corrected module block
module "api_gateway" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/api-gateway"

  name                = "strapi-admin-${var.environment}"
  domain_name         = "admin-${var.environment}.${var.root_domain_name}"
  acm_certificate_arn = data.aws_acm_certificate.this.arn
  # Configure for Lambda integration
  integration_type      = "AWS_PROXY"
  integration_uri       = module.strapi_lambda_proxy.lambda_function_invoke_arn
  enable_access_logging = true
  route_keys = [
    "ANY /{proxy+}",
  ]
  depends_on = [module.strapi_lambda_proxy]
}

module "strapi_lambda_proxy" {
  source     = "git@github.com:green-alchemist/terraform-modules.git//modules/lambda-proxy"
  depends_on = [module.strapi_fargate] # Ensure Fargate service is ready

  service_name = "strapi-admin-proxy"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.private_subnets.subnet_ids

  target_service_name       = "strapi-admin-service"
  service_connect_namespace = aws_service_discovery_private_dns_namespace.service_connect.name
  target_port               = 1337

  enable_service_discovery_permissions = true
  xray_tracing_enabled                 = true
  runtime                              = "nodejs20.x"
  memory_size                          = 512
  timeout                              = 60
  log_retention_days                   = 30
  log_level                            = "INFO"
  enable_monitoring                    = true
  error_threshold                      = 25
  throttle_threshold                   = 10

  tags = {
    Environment = var.environment
    Service     = "strapi-admin"
    ManagedBy   = "terraform"
  }
}

# The "glue" resource that connects the two modules, breaking the circular dependency.
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.strapi_lambda_proxy.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.execution_arn}/*/*"
}

