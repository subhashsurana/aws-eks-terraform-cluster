variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "cluster_full_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "workers_ami_id" {
  type = string
}

variable "workers_instance_type" {
  type = string
}

variable "workers_number_min" {
  type = string
}

variable "workers_number_max" {
  type = string
}

variable "workers_storage_size" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "aws_region" {
  type = string
}

variable "clusters_name_prefix" {
  type = string
}

variable "node_group_name" {
  description = "Name of the Node Group"
  type        = string
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type        = string
}

variable "instance_types" {
  type        = list(string)
  description = "Set of instance types associated with the EKS Node Group."
}

variable "capacity_type" {
  type        = string
  description = "Capacity type to be either as 'ON-DEMAND' or 'SPOT' "

}

variable "workers_desired_size" {
  description = "Desired number of worker nodes in a given subnet"
  type        = number
}