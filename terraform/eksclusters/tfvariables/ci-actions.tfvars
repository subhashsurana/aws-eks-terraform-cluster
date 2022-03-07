aws_region            = "us-east-2"
clusters_name_prefix  = "ci-actions-cluster"
cluster_version       = "1.21"
workers_instance_type = "t3.medium"
workers_number_min    = 1
workers_number_max    = 3
workers_storage_size  = 50
node_group_name       = "spot-private-node_group"
capacity_type         = "SPOT"
workers_desired_size  = 1
instance_types = ["m5.xlarge",
"m5a.xlarge",
"m5ad.xlarge",
"m5d.xlarge",
"m5dn.xlarge",
"m5n.xlarge",
"m5zn.xlarge"]

#  disk_size = 20
generated_key_name = "eks-key"