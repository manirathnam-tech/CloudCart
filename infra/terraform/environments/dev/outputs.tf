output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the dev VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block of the dev VPC"
}

output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
  description = "The ID of the dev Internet Gateway"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "The IDs of the dev public subnets"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The IDs of the dev private subnets"
}

output "data_subnet_ids" {
  value       = module.vpc.data_subnet_ids
  description = "The IDs of the dev data subnets"
}

output "nat_gateway_ids" {
  value       = module.vpc.nat_gateway_ids
  description = "The IDs of the NAT Gateway(s)"
}

output "public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "The ID of the public route table"
}

output "private_route_table_id" {
  value       = module.vpc.private_route_table_id
  description = "The ID of the private route table"
}

output "data_route_table_id" {
  value       = module.vpc.data_route_table_id
  description = "The ID of the data route table"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the dev EKS cluster - use with aws eks update-kubeconfig --name <this>"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The API server endpoint for the dev EKS cluster"
}

output "eks_cluster_security_group_id" {
  value       = module.eks.cluster_security_group_id
  description = "The dedicated SG on the EKS control plane"
}

output "eks_cluster_iam_role_arn" {
  value       = module.eks.cluster_iam_role_arn
  description = "The IAM role ARN the EKS control plane assumes"
}
