# locals {
#   envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.5"
#     }
#     circleci = {
#       source  = "mrolla/circleci"
#       version = "0.6.1"
#     }
#   }

#   backend "s3" {
#     bucket  = "kc-tf-state"
#     key     = "strapi-admin.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#     # kms_key_id     = "alias/kc-tf-state"
#     dynamodb_table = "kc-terraform-lock"
#   }
# }

# provider "aws" {
#   # shared_credentials_files = ["~/.aws/credentials"]
#   profile = var.aws_profile
#   region  = var.aws_region
# }

provider "circleci" {
  api_token    = locals.envs["CIRCLECI_CLI_TOKEN"]
  organization = locals.envs["CIRCLECI_ORGANIZATION"]
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# --- Networking ---
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

# --- IAM & Security ---
module "ecs_task_execution_role" {
  source    = "git@github.com:green-alchemist/terraform-modules.git//modules/ecs-task-execution-role"
  role_name = "strapi-admin-task-execution-role"
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

# --- Database ---
module "aurora_db" {
  source           = "git@github.com:green-alchemist/terraform-modules.git//modules/aurora-serverless"
  database_name    = "strapi"
  master_username  = "strapiadmin"
  master_password  = var.db_password
  subnet_ids       = [module.public_subnet.public_subnet_id]
  security_group_ids = [module.aurora_security_group.security_group_id]
}

# --- Application ---
module "strapi_ecrs" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/ecr"
  ecrs = {
    "strapi-admin-dev" = {
      tags = { Service = "strapi-admin-dev", Env = "dev" }
    }
  }
}

module "strapi_fargate" {
  source                      = "git@github.com:green-alchemist/terraform-modules.git//modules/fargate"
  cluster_name                = "strapi-admin-cluster"
  task_family                 = "strapi-admin-task"
  service_name                = "strapi-admin-service"
  container_name              = "strapi-admin"
  ecr_repository_url          = module.strapi_ecrs.urls["strapi-admin-dev"]
  ecs_task_execution_role_arn = module.ecs_task_execution_role.role_arn
  subnet_ids                  = [module.public_subnet.public_subnet_id]
  security_group_ids          = [module.strapi_security_group.security_group_id]

  environment_variables = {
    DATABASE_CLIENT   = "postgres"
    DATABASE_HOST     = module.aurora_db.cluster_endpoint
    DATABASE_PORT     = module.aurora_db.cluster_port
    DATABASE_NAME     = module.aurora_db.database_name
    DATABASE_USERNAME = "strapiadmin"
    DATABASE_PASSWORD = var.db_password
  }
}

# module "vpc" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//AWS/modules/vpc"
# }

# module "public_subnet" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//AWS/modules/public-subnet"

#   vpc_id = module.vpc.vpc_id
# }

# module "internet_gateway" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//AWS/modules/internet-gateway"

#   vpc_id = module.vpc.vpc_id
# }

# module "route_table" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//AWS/modules/route-table"

#   vpc_id              = module.vpc.vpc_id
#   internet_gateway_id = module.internet_gateway.internet_gateway_id
#   public_subnet_id    = module.public_subnet.public_subnet_id
# }

# module "ec2" {
#   source = "git@github.com:green-alchemist/terraform-modules.git//AWS/modules/ec2"

#   vpc_id                  = module.vpc.vpc_id
#   public_subnet_id        = module.public_subnet.public_subnet_id

#   ec2_ssh_key_name        = var.ec2_ssh_key_name
#   ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
# }

