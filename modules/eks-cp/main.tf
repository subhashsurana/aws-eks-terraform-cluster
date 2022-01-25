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

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_full_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    subnet_ids         = [for s in data.aws_subnet.subnets : s.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_clusterrole_policy_attachment,
    aws_iam_role_policy_attachment.eks_servicerole_policy_attachment,
  ]

}