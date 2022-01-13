resource "aws_vpc" "eks_vpc" {
    cidr_block = var.eks_vpc_block
    enable_dns_hostnames = true
    tags = merge(
        var.common_tags,
        {
            Name = "${var.clusters_name_prefix}-vpc"
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

