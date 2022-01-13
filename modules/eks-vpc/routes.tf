resource "aws_route_table" "eks_private_route_tables" {
    count = length(var.eks_private_subnets_prefix_list)
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        Name = "private"
    }
}

resource "aws_route" "eks_private_routes" {
    count = length(var.eks_private_subnets_prefix_list)
    route_table_id = element(aws_route_table.eks_private_route_tables.*.id, count.index)
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.eks_nat_gws.*.id, count.index)
    timeouts {
      create = "5m"
    }
}

resource "aws_route_table" "eks_public_route_tables" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
      "Name" = "public"
    }
}


resource "aws_route" "eks_public_route" {
    route_table_id = aws_route_table.eks_public_route_tables.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
    timeouts {
      create = "5m"
    }
}

resource "aws_route_table_association" "eks_private_rt_association" {
  count          = length(var.eks_private_subnets_prefix_list)
  route_table_id = element(aws_route_table.eks_private_route_tables.*.id, count.index)
  subnet_id      = element(aws_subnet.eks_private_subnets.*.id, count.index)
}

resource "aws_route_table_association" "eks_public_rt_association" {
  count          = length(var.eks_public_subnets_prefix_list)
  route_table_id = element(aws_route_table.eks_public_route_tables.*.id, count.index)
  subnet_id      = element(aws_subnet.eks_public_subnets.*.id, count.index)
}

