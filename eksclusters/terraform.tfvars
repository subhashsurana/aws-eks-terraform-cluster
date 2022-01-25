aws_region = "us-east-2"
#private_subnet_ids = [
#  "10.1.0.0/20",
#  "10.1.16.0/20",
# ]
# public_subnet_ids = [
#  "10.1.32.0/20",
#  "10.1.48.0/20",
# ]

vpc_id                = "vpc-0dae30e35f0e9118e"
clusters_name_prefix  = "ci-actions-cluster"
cluster_version       = "1.21"
workers_instance_type = "t3.medium"
workers_number_min    = 1
workers_number_max    = 3
workers_storage_size  = 10
node_group_name = "on-demand-private-ng"
capacity_type = "ON_DEMAND"
 workers_desired_size = 1
instance_types = ["t3-medium"]
 ami_type = "AL2_x86_64"
 disk_size = 20