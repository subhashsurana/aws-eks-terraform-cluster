# Nodes in private subnets
resource "aws_eks_node_group" "private-node-group" {
  cluster_name    = var.cluster_full_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnet_ids])

  instance_types = var.instance_types

  capacity_type = var.capacity_type

  scaling_config {
    desired_size = var.workers_desired_size
    max_size     = var.workers_number_max
    min_size     = var.workers_number_min
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    "role" = "general"
     "eks/cluster-name"   = var.cluster_full_name
     "eks/nodegroup-name" = var.node_group_name
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  launch_template {
    name    = aws_launch_template.workers.name
    version = aws_launch_template.workers.latest_version
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = {
    Name = var.node_group_name
    "eks/cluster-name"                = var.cluster_full_name
    "eks/nodegroup-name"              = var.node_group_name
    "eks/nodegroup-type"              = "managed"
    "eksnet" = "net-main"
  }
  
  timeouts {}

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.workers
  ]
}