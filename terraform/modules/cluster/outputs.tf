output "cluster_full_name" {
  value = module.eks.cluster_name
}

output "cluster_cert_authority" {
  value = module.eks.cert_authority
}

output "cluster_api" {
  value = module.eks.cluster_endpoint
}

output "cluster_open_id_connect-issuer" {
  value = module.eks.identity_oidc_issuer
}

output "cluster_eks_autoscaler_arn" {
  value = module.eks.eks_cluster_autoscaler_arn
}

output "open_id_connect_S3_iam_arn" {
  value = module.eks.s3_oidc_iam_arn
}

output "cluster_tag" {
  value = module.workers.tag
}

output "worker_iam_role_name" {
  value = module.workers.iam_role_name
}

output "worker_iam_role_arn" {
  value = module.workers.iam_role_arn
}

output "worker_node_group_name" {
  value = module.workers.node_group_name
}

output "worker_security_group" {
  value = module.workers.security_group_id
}

output "workers_userdata" {
  value = module.workers.userdata
}

output "authconfig" {
  value = module.workers.authconfig
}



