module "ekscluster" {
  source                = "../modules/cluster"
  clusters_name_prefix  = var.clusters_name_prefix
  cluster_full_name     = "${var.clusters_name_prefix}-${element(split("-", terraform.workspace), 0)}"
  cluster_version       = var.cluster_version
  workers_instance_type = var.workers_instance_type
  workers_ami_id        = data.aws_ssm_parameter.workers_ami_id.value
  workers_number_min    = var.workers_number_min
  workers_number_max    = var.workers_number_max
  workers_desired_size  = var.workers_desired_size
  workers_storage_size  = var.workers_storage_size
  common_tags           = local.common_tags
  aws_region            = var.aws_region
  node_group_name       = var.node_group_name
  capacity_type         = var.capacity_type
  instance_types        = var.instance_types
  # disk_size             = var.disk_size
  generated_key_name = var.generated_key_name
}

locals {
  common_tags = {
    ManagedBy   = "terraform"
    ClusterName = "${var.clusters_name_prefix}-${element(split("-", terraform.workspace), 0)}"
  }
}