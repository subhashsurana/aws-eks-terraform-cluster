output "vpc_id" {
  value = module.vpc.eks_cluster_vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.eks_private_subnets_ids
}

output "public_subnet_ids" {
  value = module.vpc.eks_public_subnets_ids
}