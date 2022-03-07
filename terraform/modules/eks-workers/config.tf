data "terraform_remote_state" "vpc_state" {
  backend = "s3"
  config = {
    bucket = "${cluster-name-prefix}-vpc-terraform-state"
    key    = "env://${element(split("-", terraform.workspace), 0)}/${cluster-name-prefix}-vpc.tfstate"
    region = "us-east-2"
  }
}
