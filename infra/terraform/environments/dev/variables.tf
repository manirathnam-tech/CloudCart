variable "env" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "data_subnet_cidrs" {
  description = "The CIDR blocks for the data subnets"
  type        = list(string)
}
