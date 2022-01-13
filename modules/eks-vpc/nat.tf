resource "aws_eip" "eks_nat_ips" {
    count = length(var.eks_public_subnets_prefix_list)
    vpc = true
  
}

resource "aws_nat_gateway" "eks_nat_gws" {
    count         = length(var.eks_public_subnets_prefix_list)
    allocation_id = element(aws_eip.eks_nat_ips.*.id, count.index)
    subnet_id = element(aws_subnet.eks_public_subnets.*.id, count.index)
}