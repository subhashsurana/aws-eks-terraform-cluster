aws_region = "us-east-2"
vpc_block = "10.1.0.0/16"
clusters_name_prefix = "spot-actions-cluster"

private_subnets_prefix_list = [
    "10.1.0.0/20",
    "10.1.16.0/20",
]

public_subnets_prefix_list = [
    "10.1.32.0/20",
    "10.1.48.0/20",
]


