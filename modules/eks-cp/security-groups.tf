resource "aws_security_group" "eks_cluster_sg" {
  name        = var.cluster_full_name
  description = "EKS cluster Security group"
  vpc_id = data.terraform_remote_state.vpc_state.outputs.vpc_id
  tags = merge(
    var.common_tags,
    {
      Name                                             = "${var.cluster_full_name}-cluster-sg"
      "kubernetes.io/cluster/${var.cluster_full_name}" = "owned"
    },
  )

}