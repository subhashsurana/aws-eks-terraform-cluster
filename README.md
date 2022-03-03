
Provision the EKS infrastructure using Terraform on AWS using Managed Nodegroups and launch Templates with custom EKS Optmized AMI

### Terminologies: 

`#` Terraform State - State of your managed infrastructure & configuration which maps real world resources to your config, keeping track of metadata and is generally stored in a local file named 'terraform.tfsate' which can also be stored remotely   

`#` Terraform Lock - Locking mechanism for State file provided by the Backend. Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.


`#` Terraform backend - Backends define where Terraform's state snapshots are stored. Terraform uses this persisted state data to keep track of the resources it manages.

`#` Remote State: Terraform writes the state data to a remote data store (here S3), which can then be shared between all members of a team. Remote state is implemented by a backend like S3 or Terraform cloud.

The root module shared-state will create the required [Terraform Backend](https://www.terraform.io/docs/backends/index.html) which stores the terraform.tfstate file in an S3 bucket and uses a DynamoDB table for state locking and consistency checking. 

Terraform can lock your state to prevent other users from breaking the infrastructure using the same state file at the same time. In other words, while a user is working on the infrastructure with Terraform, another user cannot work on the same state file simultaneously.

If you want to use S3 as a backend in Terraform, first, you must create an S3 bucket and then specify that bucket in your config file as backend. Now we create our S3 bucket for remote state and Amazon DynamoDB table for Locking state. 

>Note: A single DynamoDB table can be used to lock multiple remote state files. 

>For Production, please set lifecycle (prevent_destroy): true which prevents the bucket to be accidentally deleted.


```Warning: It is highly recommended that you enable Bucket Versioning on the S3 bucket to allow for state recovery in the case of accidental deletions and human error.```



# Provision the infrastructure

## Create terraform shared state

```
cd shared-state
terraform init
terraform apply
```

## Create cluster VPC and network

```
cd ekscluster-vpc
terraform workspace new test
terraform init 
terraform apply
```

## Create cluster resources

```


cd eksclusters
terraform workspace new test-cluster                
terraform init 
terraform apply
```

## Verify the cluster

```
kubectl get nodes
kubectl get namespaces
kubectl get pods --all-namespaces
```

# Destroy the infrastructure

## Destroy cluster resources

```
cd eksclusters
terraform workspace select test-cluster             
terraform init 
terraform destroy
```

## Destroy cluster VPC and network

```
cd ekscluster-vpc
terraform workspace select test
terraform init 
terraform destroy
```

# Destroy terraform shared state
```
cd shared-state 
terraform init 
terraform destroy
```

