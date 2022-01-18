terraform {
  backend "s3" {
    bucket         = "spot-actions-cluster-vpc-terraform-state"
    key            = "spot-actions-cluster-vpc.tfstate"
    region         = "us-east-2"
    dynamodb_table = "spot-actions-cluster-vpc-terraform-state-lock-dynamodb"
    encrypt = "true"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.71.0"
    }
  }
  required_version = "~> 1.1.0"
}

data "aws_ssm_parameter" "workers_ami_id" {
  name            = "/aws/service/eks/optimized-ami/1.15/amazon-linux-2/recommended/image_id"
  with_decryption = false
}