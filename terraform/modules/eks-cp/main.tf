
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_full_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    subnet_ids              = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnet_ids])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = [
      "0.0.0.0/0",
    ]

  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_clusterrole_policy_attachment,
    aws_iam_role_policy_attachment.eks_servicerole_policy_attachment,
  ]

}