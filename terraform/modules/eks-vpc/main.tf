resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    var.common_tags,
    {
      Name                                                                       = "${var.clusters_name_prefix}-vpc"
      "kubernetes.io/cluster/${var.clusters_name_prefix}-${terraform.workspace}" = "shared"
    },
  )
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

data "aws_availability_zones" "availability_zones" {

}

