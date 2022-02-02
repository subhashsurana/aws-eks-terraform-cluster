terraform {
  backend "s3" {
    bucket         = "ci-actions-cluster-terraform-state"
    key            = "ci-actions-cluster.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ci-actions-cluster-terraform-state-lock-dynamodb"
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

data "aws_ssm_parameter" "workers_ami_id" {
  name            = format("/aws/service/eks/optimized-ami/%s/amazon-linux-2/recommended/image_id",var.cluster_version)
  with_decryption = false
}