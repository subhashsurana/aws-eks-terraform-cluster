terraform {
  backend "s3" {
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
  name            = format("/aws/service/eks/optimized-ami/%s/amazon-linux-2/recommended/image_id", var.cluster_version)
  with_decryption = false
}