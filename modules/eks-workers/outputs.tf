output "node_group_name" {
  value = aws_eks_node_group.private-node-group.node_group_name
}

output "security_group_id" {
  value = aws_security_group.workers.id
}

output "iam_role_arn" {
  value = aws_iam_role.workers.arn
}

output "iam_role_name" {
  value = aws_iam_role.workers.name
}

output "tag" {
  value = "kubernetes.io/cluster/${var.cluster_full_name}"
}

# output "instance_profile" {
#   value = aws_iam_instance_profile.workers.arn
# }

output "userdata" {
  value = local.eks_node_private_userdata
}

output "authconfig" {
  value = local.authconfig
}