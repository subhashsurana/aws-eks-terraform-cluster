# variable "vpc_id" {
#   type = string
# }

# variable "private_subnet_ids" {
#   type = list(string)
# }

variable "cluster_full_name" {
  type = string
}

variable "cluster_security_group" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_cert_authority" {
  type = string
}

variable "workers_ami_id" {
  type = string
}

variable "workers_instance_type" {
  type = string
}

variable "workers_number_min" {
  type = number
}

variable "workers_number_max" {
  type        = number
  description = "Maximum number of workers in a given subnet"
}

variable "workers_desired_size" {
  description = "Desired number of worker nodes in a given subnet"
  default     = 1
  type        = number
}


variable "workers_storage_size" {
  type        = string
  description = "Launch Template ebs assigned storage size"
}

variable "common_tags" {
  type = map(string)
}

variable "node_group_name" {
  description = "Name of the Node Group"
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

# variable "disk_size" {
#   description = "Disk size in GB for worker nodes. Defaults to 20."
#   type = number
#   default = 20
# }

variable "generated_key_name" {
  description = "SSH key pair to be generated"
  type        = string
}