terraform {
  backend "s3" {
    bucket         = "ci-actions-cluster-vpc-terraform-state"
    key            = "ci-actions-cluster-vpc.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ci-actions-cluster-vpc-terraform-state-lock-dynamodb"
    encrypt        = "true"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.71.0"
    }
  }
  required_version = "~> 1.1.0"
}

provider "aws" {
  region = var.aws_region
}