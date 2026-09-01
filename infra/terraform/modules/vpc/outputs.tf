output "vpc_id" {
  value       = aws_vpc.CloudCart_vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.CloudCart_subnet_public[*].id
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.CloudCart_subnet_private[*].id
  description = "The IDs of the private subnets"
}

output "data_subnet_ids" {
  value       = aws_subnet.CloudCart_subnet_data[*].id
  description = "The IDs of the data subnets"
}

output "vpc_cidr_block" {
  value       = aws_vpc.CloudCart_vpc.cidr_block
  description = "The CIDR block of the VPC"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.CloudCart_igw.id
  description = "The ID of the Internet Gateway"
}

output "nat_gateway_ids" {
  value       = [aws_nat_gateway.CloudCart_nat_gw.id]
  description = "The IDs of the NAT Gateway(s)"
}

output "public_route_table_id" {
  value       = aws_route_table.CloudCart_public_rt.id
  description = "The ID of the public route table"
}

output "private_route_table_id" {
  value       = aws_route_table.CloudCart_private_rt.id
  description = "The ID of the private route table"
}

output "data_route_table_id" {
  value       = aws_route_table.CloudCart_data_rt.id
  description = "The ID of the data route table"
}
