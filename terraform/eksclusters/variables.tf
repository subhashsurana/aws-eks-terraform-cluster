variable "aws_region" {
  type = string
}

variable "clusters_name_prefix" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "workers_storage_size" {
  type = string
}

# variable "vpc_id" {
#   type = string
# }

# variable "public_subnet_ids" {
#   type = list(string)
# }

# variable "private_subnet_ids" {
#   type = list(string)
# }

variable "workers_instance_type" {
  type = string
}

variable "workers_number_min" {
  type = string
}

variable "workers_number_max" {
  type = string
}

variable "workers_desired_size" {
  description = "Desired number of worker nodes in a given subnet"
  type = number
}

variable "node_group_name" {
  description = "Name of the Node Group"
  type = string
}

# variable "ami_type" {
#   description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
#   type = string
# }

variable "instance_types" {
  type = list(string)
  description = "Set of instance types associated with the EKS Node Group."
}

variable "capacity_type" {
  type = string
  description = "Capacity type to be either as 'ON-DEMAND' or 'SPOT' "

}

variable "disk_size" {
  description = "Disk size in GB for worker nodes. Defaults to 20."
  type = number
}