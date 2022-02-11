output "aws_region" {
  value = var.aws_region
}

output "cluster_full_name" {
  value = "${var.clusters_name_prefix}-${element(split("-", terraform.workspace), 0)}"
}

output "cluster_version" {
  value = var.cluster_version
}

output "cluster_api" {
  value = module.ekscluster.cluster_api
}

output "cluster_tag" {
  value = module.ekscluster.cluster_tag
}

output "worker_iam_role_arn" {
  value = module.ekscluster.worker_iam_role_arn
}

# output "authconfig" {
#   value = module.ekscluster.authconfig
# }

output "cluster_cert_authority" {
  value = module.ekscluster.cluster_cert_authority
}


output "cluster_open_id_connect-issuer" {
  value = module.ekscluster.cluster_open_id_connect-issuer
}

output "cluster_eks_autoscaler_arn" {
  value = module.ekscluster.cluster_eks_autoscaler_arn
}

output "open_id_connect_S3_iam_arn" {
  value = module.ekscluster.open_id_connect_S3_iam_arn
}
