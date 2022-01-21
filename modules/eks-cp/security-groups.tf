resource "aws_security_group" "eks_security_cluster" {
  name        = var.cluster_full_name
  description = "EKS cluster Security group"
  vpc_id      = var.vpc_id
  tags = merge(
    var.common_tags,
    {
      Name                                             = "${var.cluster_full_name}-cluster-sg"
      "kubernetes.io/cluster/${var.cluster_full_name}" = "owned"
    },
  )

}