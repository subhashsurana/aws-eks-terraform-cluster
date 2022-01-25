data "aws_subnet_ids" "subnet_ids" {
  vpc_id = var.vpc_id
 }

 data "aws_subnet" "subnets" {
    for_each = data.aws_subnet_ids.subnet_ids.ids
    id         = each.value
    depends_on = [
    data.aws_subnet_ids.subnet_ids
  ]
  }

# Nodes in private subnets
resource "aws_eks_node_group" "private-node-group" {
  cluster_name    = var.cluster_full_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = [for s in data.aws_subnet.subnets : s.id]

  ami_type       = var.ami_type
# disk_size      = var.disk_size
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
    role = "general"
  }

  taint {
    key    = "team"
    value  = "devops"
    effect = "NO_SCHEDULE"
  }

  launch_template {
    name    = aws_launch_template.workers.name
#   id      = aws_launch_template.workers.id
    version = aws_launch_template.workers.latest_version
  }

  tags = {
    Name = var.node_group_name
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}