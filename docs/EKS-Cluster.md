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
