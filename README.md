
Provision the EKS infrastructure using Terraform on AWS using Managed Nodegroups and launch Templates with EKS Optmized AMI.

## Tools Setup

#### Please check the [docs](https://github.com/Dealermade/aws-terraform-eks-cluster/blob/main/docs/Tools-setup.md) directory for setting up the required software and configuration required for setting up EKS Cluster in AWS Using Terraform.

---

### EKS Cluster Creation - Infrastructure 

#### Please check the [docs/EKS-Cluster](https://github.com/Dealermade/aws-terraform-eks-cluster/blob/main/docs/EKS-Cluster.md) Readme for the detailed steps required to provision & Tear down the cluster Terraform

---
### Terminologies: 

`#` Terraform State - State of your managed infrastructure & configuration which maps real world resources to your config, keeping track of metadata and is generally stored in a local file named 'terraform.tfsate' which can also be stored remotely   

`#` Terraform Lock - Locking mechanism for State file provided by the Backend. Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.


`#` Terraform backend - Backends define where Terraform's state snapshots are stored. Terraform uses this persisted state data to keep track of the resources it manages.

`#` Remote State: Terraform writes the state data to a remote data store (here S3), which can then be shared between all members of a team. Remote state is implemented by a backend like S3 or Terraform cloud.

***Shared State***


The root module shared-state will create the required [Terraform Backend](https://www.terraform.io/docs/backends/index.html) which stores the terraform.tfstate file in an S3 bucket and uses a DynamoDB table for state locking and consistency checking. 

Terraform can lock your state to prevent other users from breaking the infrastructure using the same state file at the same time. In other words, while a user is working on the infrastructure with Terraform, another user cannot work on the same state file simultaneously.

If you want to use S3 as a backend in Terraform, first, you must create an S3 bucket and then specify that bucket in your config file as backend. Now we create our S3 bucket for remote state and Amazon DynamoDB table for Locking state. 

>Note: A single DynamoDB table can be used to lock multiple remote state files. 

>For Production, please set lifecycle (prevent_destroy): true which prevents the bucket to be accidentally deleted.


```Warning: It is highly recommended that you enable Bucket Versioning on the S3 bucket to allow for state recovery in the case of accidental deletions and human error.```

***VPC Modules*** 

After the shared state is created, the VPC module will create the required VPC components for the required Networking Infrastructure as below:

- VPC with CIDR block (input to be defined in terraform.tfvars)
- Subnets - 2 Private & Public each (input to be defined in terraform.tfvars file)
- Nat Gateways for Private Subnets
- Internet Gateway for both Public Subnets
- Route Tables & routes for both Public & Private Subnets
- Elastic IP Addresses for the Nat Gateway

We will be using the remote backend "S3" and bucket and DynamoDB table names required to be changed as per the Cluster name.

Here we are using the latest supported Kubernetes Version 1.21 for EKS.
For latest versions upgrade click [Amazon EKS Kubernetes Versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)

We will be fetching the VPC and subnet ids that were created from the previous module using Terraform remote state pulling from the S3 Backend.
Here We cannot use variable interpolation inside bucket name to have generic fucntionality as we need to change the hard-coded values for the bucket and Table. Please see the current limitations while using backend. 

> A backend block cannot refer to named values (like input variables, locals, or data source attributes).[Backend Configuration](https://www.terraform.io/language/settings/backends/configuration)

To work out the above limitations, we can use Partial Configuration options to keep empty backend as below and move the remaining backend configuration arguments (required and optional) to a new file stored inside a sub-directory (/backends) and provide the path of this file using ``-backend-config`` and utilizing `` -reconfigure`` option during terraform init command so  to use the new backend settings.  

```
terraform {
  backend "s3" {}
}
```
---

Once the VPC networking components are created via Terraform commands, the EKS Cluster needs to be created and then eventually the Worker nodes that will join the Cluster on the Master Control plane.

***Cluster Components***
The EKS Cluster will be created on Private Subnets with public and private endpoint to be connected from the local workstation for accessing Kubernetes API Server

- IAM roles for Cluster - To add below managed policies

        AmazonEKSClusterPolicy        
        AmazonEKSServicePolicy

- OpenId Connect Provider - Service Account (OIDC)
- IAM roles for Auto Scaler - Below managed are policies required for EKS autoscaler
    
         autoscaling:DescribeAutoScalingGroups 
         autoscaling:DescribeAutoScalingInstances 
         autoscaling:DescribeLaunchConfigurations 
         autoscaling:DescribeTags   
         autoscaling:SetDesiredCapacity 
         autoscaling:TerminateInstanceInAutoScalingGroup 
         ec2:DescribeLaunchTemplateVersions

***Worker Components***
- IAM Roles for worker nodes

        AmazonEKSWorkerNodePolicy
        AmazonEKS_CNI_Policy
        AmazonEC2ContainerRegistryReadOnly
        CloudWatchAgentServerPolicy
        AmazonSSMManagedInstanceCore

- Managed Nodegroups

Amazon EKS managed node groups automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for Amazon EKS Kubernetes clusters.

With Amazon EKS managed node groups, you don’t need to separately provision or register the Amazon EC2 instances that provide compute capacity to run your Kubernetes applications. You can create, automatically update, or terminate nodes for your cluster with a single operation. Node updates and terminations automatically drain nodes to ensure that your applications stay available.

Every managed node is provisioned as part of an Amazon EC2 Auto Scaling group that's managed for you by Amazon EKS. Each node group runs across multiple Availability Zones that you define.

Nodes launched as part of a managed node group are automatically tagged for auto-discovery by the Kubernetes cluster autoscaler.

*``If you are running a stateful application across multiple Availability Zones that is backed by Amazon EBS volumes and using the Kubernetes Cluster Autoscaler, you should configure multiple node groups, each scoped to a single Availability Zone. In addition, you should enable the --balance-similar-node-groups feature.``*

Some Basic Points while creating Managed Node Groups

1. You can create multiple managed node groups within a single cluster.
2. You can use a custom launch template for a greater level of flexibility and customization when deploying managed nodes. EKS Optimized AMIs should be used while creating launch template.

3. When managed nodes run an Amazon EKS optimized AMI, Amazon EKS is responsible for building patched versions of the AMI when bugs or issues are reported. We can publish a fix. However, you're responsible for deploying these patched AMI versions to your managed node groups.

4. Amazon EKS managed node groups can be launched in both public and private subnets. If you launch a managed node group in a public subnet on or after April 22, 2020, the subnet must have MapPublicIpOnLaunch set to true for the instances to successfully join a cluster. 

5. Amazon EKS adds Kubernetes labels to managed node group instances. These Amazon EKS provided labels are prefixed with eks.amazonaws.com.

6. Amazon EKS adds Kubernetes labels to managed node group instances. These Amazon EKS provided labels are prefixed with eks.amazonaws.com.

---
Managed node group capacity types

When creating a managed node group, you can choose either the On-Demand or Spot capacity type. Amazon EKS deploys a managed node group with an Amazon EC2 Auto Scaling Group that either contains only On-Demand or only Amazon EC2 Spot Instances. You can schedule pods for fault tolerant applications to Spot managed node groups, and fault intolerant applications to On-Demand node groups within a single Kubernetes cluster.

On-Demand

With On-Demand Instances, you pay for compute capacity by the second, with no long-term commitments. 

By default, Capacity-type is set to On-Demand

The allocation strategy to provision On-Demand capacity is set to prioritized. Managed node groups use the order of instance types passed in the API to determine which instance type to use first when fulfilling On-Demand capacity. For example, you might specify three instance types in the following order: c5.large, c4.large, and c3.large. When your On-Demand Instances are launched, the managed node group fulfills On-Demand capacity by starting with c5.large, then c4.large, and then c3.large. 

Spot

Amazon EC2 Spot Instances are spare Amazon EC2 capacity that offers steep discounts off of On-Demand prices. Amazon EC2 Spot Instances can be interrupted with a two-minute interruption notice when EC2 needs the capacity back. 

To use Spot Instances inside a managed node group, create a managed node group by setting the capacity type as spot. A managed node group configures an Amazon EC2 Auto Scaling group on your behalf with the following Spot best practices applied:

-    The allocation strategy to provision Spot capacity is set to capacity-optimized to ensure that your Spot nodes are provisioned in the optimal Spot capacity pools. To increase the number of Spot capacity pools available for allocating capacity from, configure a managed node group to use multiple instance types.

-    Amazon EC2 Spot Capacity Rebalancing is enabled so that Amazon EKS can gracefully drain and rebalance your Spot nodes to minimize application disruption when a Spot node is at elevated risk of interruption.

     -  When a Spot node receives a rebalance recommendation, Amazon EKS automatically attempts to launch a new replacement Spot node and waits until it successfully joins the cluster.

     -   When a replacement Spot node is bootstrapped and in the Ready state on Kubernetes, Amazon EKS cordons and drains the Spot node that received the rebalance recommendation. Cordoning the Spot node ensures that the service controller doesn't send any new requests to this Spot node. It also removes it from its list of healthy, active Spot nodes. Draining the Spot node ensures that running pods are evicted gracefully.

     -   If a Spot two-minute interruption notice arrives before the replacement Spot node is in a Ready state, Amazon EKS starts draining the Spot node that received the rebalance recommendation.



-   Amazon EKS adds the following Kubernetes label to all nodes in your managed node group that specifies the capacity type: eks.amazonaws.com/capacityType: SPOT. You can use this label to schedule fault tolerant applications on Spot nodes.

- To maximize the availability of your applications while using Spot Instances, we recommend that you configure a Spot managed node group to use multiple instance types. We recommend applying the following rules when using multiple instance types:

    -   Within a managed node group, if you're using the Cluster Autoscaler, we recommend using a flexible set of instance types with the same amount of vCPU and memory resources. This is to ensure that the nodes in your cluster scale as expected. For example, if you need four vCPUs and eight GiB memory, use c3.xlarge, c4.xlarge, c5.xlarge, c5d.xlarge, c5a.xlarge, c5n.xlarge, or other similar instance types.

    -   To enhance application availability, we recommend deploying multiple Spot managed node groups. For this, each group should use a flexible set of instance types that have the same vCPU and memory resources. For example, if you need 4 vCPUs and 8 GiB memory, we recommend that you create one managed node group with c3.xlarge, c4.xlarge, c5.xlarge, c5d.xlarge, c5a.xlarge, c5n.xlarge, or other similar instance types, and a second managed node group with m3.xlarge, m4.xlarge, m5.xlarge, m5d.xlarge, m5a.xlarge, m5n.xlarge or other similar instance types.

``Spot Instances are a good fit for stateless, fault-tolerant, flexible applications.`` 

Check for more details in AWS Documentation [Managed Nodegroups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)

- Launch Templates

Managed node groups are always deployed with a launch template to be used with the Amazon EC2 Auto Scaling Group. The Amazon EKS API creates this launch template either by copying one you provide or by creating one automatically with default values in your account.

After you deployed a managed node group with your own launch template, update it with a different version of the same launch template. When you update your node group to a different version of your launch template, all nodes in the group are recycled to match the new configuration of the specified launch template version. 

Check for more details in AWS Documentation [Launch Templates](https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html)

>By default, Amazon EKS applies the cluster security group to the instances in your node group to facilitate communication between nodes and the control plane. So, you must ensure that the inbound and outbound rules of your security groups enable communication with the endpoint of your cluster. If your security group rules are incorrect, the worker nodes can't join the cluster.

>

If you need SSH access to the instances in your node group, include a security group that allows that access.

- Amazon EC2 user data

The launch template includes a section for custom user data. You can specify configuration settings for your node group in this section without manually creating individual custom AMIs. 


