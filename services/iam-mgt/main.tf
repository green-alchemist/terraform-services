locals {
  envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
    circleci = {
      source  = "mrolla/circleci"
      version = "0.6.1"
    }
  }

  backend "s3" {
    bucket         = "kc-tf-state"
    key            = "iam-mgt.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/kc-tf-state"
    dynamodb_table = "kc-terraform-lock"
  }
}

provider "aws" {
  # shared_credentials_files = ["~/.aws/credentials"]
  profile = var.aws_profile
  region  = var.aws_region
}

provider "circleci" {
  api_token    = locals.envs["CIRCLECI_CLI_TOKEN"]
  organization = locals.envs["CIRCLECI_ORGANIZATION"]
}
