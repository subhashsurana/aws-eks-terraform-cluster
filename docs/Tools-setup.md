# Tools required for Setting up EKS Cluster Using Terraform
- AWS CLI V2
- Terraform

For Installing & configuring AWS CLI please check the [docs/AWS-setup](https://github.com/Dealermade/aws-terraform-eks-cluster/blob/main/docs/AWS-setup.md)

### Terraform Installation

Ubuntu/Debian

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install terraform
````

For other OS/Linux Versions check [Terraform Setup link](https://www.terraform.io/downloads)
