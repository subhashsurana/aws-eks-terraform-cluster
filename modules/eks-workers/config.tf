data terraform_remote_state "vpc_state" {
backend = "s3"
config = {
bucket         = "ci-actions-cluster-vpc-terraform-state"
key            = "env://${element(split("-", terraform.workspace), 0)}/ci-actions-cluster-vpc.tfstate"
region         = "us-east-2"
}
}