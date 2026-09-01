resource "aws_vpc" "CloudCart_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "CloudCart_VPC"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "CloudCart_igw" {
  vpc_id = aws_vpc.CloudCart_vpc.id

  tags = {
    Name        = "CloudCart_IGW"
    Environment = var.env
  }
}

resource "aws_subnet" "CloudCart_subnet_public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.CloudCart_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env}-public-${var.availability_zones[count.index]}"
    Environment = var.env
  }
}

resource "aws_subnet" "CloudCart_subnet_private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.CloudCart_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.env}-private-${var.availability_zones[count.index]}"
    Environment = var.env
  }
}

resource "aws_subnet" "CloudCart_subnet_data" {
  count             = length(var.data_subnet_cidrs)
  vpc_id            = aws_vpc.CloudCart_vpc.id
  cidr_block        = var.data_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.env}-data-${var.availability_zones[count.index]}"
    Environment = var.env
  }
}

resource "aws_eip" "CloudCart_nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.env}-nat-eip"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "CloudCart_nat_gw" {
  allocation_id = aws_eip.CloudCart_nat_eip.id
  subnet_id     = aws_subnet.CloudCart_subnet_public[0].id
}
