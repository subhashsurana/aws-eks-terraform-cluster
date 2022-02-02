aws_region = "us-east-2"
clusters_name_prefix  = "ci-actions-cluster"
cluster_version       = "1.21"
workers_instance_type = "t3.medium"
workers_number_min    = 1
workers_number_max    = 3
workers_storage_size  = 10
node_group_name = "spot-private-node_group"
capacity_type = "SPOT"
workers_desired_size = 1
instance_types = ["m5.large",
    "m4.large",
    "m5a.large",
    "m5d.large",
    "m5n.large",
    "m5ad.large",
    "m5dn.large",
    ]
# ami_type = "AL2_x86_64"
 disk_size = 20