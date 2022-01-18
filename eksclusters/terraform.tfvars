aws_region = "us-east-2"
private_subnet_ids = [
    "10.1.0.0/20",
    "10.1.16.0/20",
]
public_subnet_ids = [
    "10.1.32.0/20",
    "10.1.48.0/20",
    ]

vpc_id = "vpc-"
clusters_name_prefix  = "eksclusters"
cluster_version       = "1.21.2"
workers_instance_type = "t3.medium"
workers_number_min    = 2
workers_number_max    = 3
workers_storage_size  = 10