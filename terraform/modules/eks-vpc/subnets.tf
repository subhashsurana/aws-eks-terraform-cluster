resource "aws_subnet" "eks_private_subnets" {
  count             = length(var.eks_private_subnets_prefix_list)
  cidr_block        = element(var.eks_private_subnets_prefix_list, count.index)
  vpc_id            = aws_vpc.eks_vpc.id
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
  tags = merge(
    var.common_tags,
    {
      Name                                                                       = "eks-private-${var.clusters_name_prefix}-${data.aws_availability_zones.availability_zones.names[count.index]}"
      "kubernetes.io/cluster/${var.clusters_name_prefix}-${terraform.workspace}" = "shared"
      "kubernetes.io/role/internal-elb"                                          = 1
    },
  )
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "eks_public_subnets" {
  count                   = length(var.eks_public_subnets_prefix_list)
  cidr_block              = element(var.eks_public_subnets_prefix_list, count.index)
  vpc_id                  = aws_vpc.eks_vpc.id
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      "Name"                                                                     = "eks-public-${var.clusters_name_prefix}-${data.aws_availability_zones.availability_zones.names[count.index]}"
      "kubernetes.io/cluster/${var.clusters_name_prefix}-${terraform.workspace}" = "shared"
      "kubernetes.io/role/elb"                                                   = "1"
    },
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}