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
