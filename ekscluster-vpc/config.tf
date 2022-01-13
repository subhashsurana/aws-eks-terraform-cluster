terraform {
  backend "s3" {
    bucket         = "spot-actions-cluster-vpc-terraform-state"
    key            = "spot-actions-cluster-vpc.tfstate"
    region         = "us-east-2"
    dynamodb_table = "spot-actions-cluster-vpc-terraform-state-lock-dynamodb"
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
  region  = var.aws_region
}