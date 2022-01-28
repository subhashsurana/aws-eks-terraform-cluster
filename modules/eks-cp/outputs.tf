output "security_group" {
  value = aws_security_group.eks_cluster_sg.id
}

output "cert_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "s3_oidc_iam_arn" {
  value = aws_iam_role.iam_oidc.arn
}

output "identity_oidc_issuer" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}