provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.aws_profile
  region                   = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
}


resource "aws_kms_key" "terraform-bucket-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
  name          = "alias/terraform-bucket-key"
  target_key_id = aws_kms_key.terraform-bucket-key.key_id
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "<BUCKET_NAME>"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform-state" {
  name           = "terraform-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


# module "vpc" {
#   source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/vpc"
# }

# module "public_subnet" {
#   source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/public-subnet"

#   vpc_id = module.vpc.vpc_id
# }

# module "internet_gateway" {
#   source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/internet-gateway"

#   vpc_id = module.vpc.vpc_id
# }

# module "route_table" {
#   source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/route-table"

#   vpc_id              = module.vpc.vpc_id
#   internet_gateway_id = module.internet_gateway.internet_gateway_id
#   public_subnet_id    = module.public_subnet.public_subnet_id
# }

# module "ec2" {
#   source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/ec2"

#   vpc_id                  = module.vpc.vpc_id
#   public_subnet_id        = module.public_subnet.public_subnet_id

#   ec2_ssh_key_name        = var.ec2_ssh_key_name
#   ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
# }