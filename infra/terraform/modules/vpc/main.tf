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

  depends_on = [aws_internet_gateway.CloudCart_igw]

  tags = {
    Name        = "${var.env}-nat-gw"
    Environment = var.env
  }
}

resource "aws_route_table" "CloudCart_public_rt" {
  vpc_id = aws_vpc.CloudCart_vpc.id

  tags = {
    Name        = "${var.env}-public-rt"
    Environment = var.env
  }
}

resource "aws_route_table" "CloudCart_private_rt" {
  vpc_id = aws_vpc.CloudCart_vpc.id

  tags = {
    Name        = "${var.env}-private-rt"
    Environment = var.env
  }
}

resource "aws_route_table" "CloudCart_data_rt" {
  vpc_id = aws_vpc.CloudCart_vpc.id

  tags = {
    Name        = "${var.env}-data-rt"
    Environment = var.env
  }
}

resource "aws_route" "CloudCart_public_default" {
  route_table_id         = aws_route_table.CloudCart_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.CloudCart_igw.id
}

resource "aws_route" "CloudCart_private_default" {
  route_table_id         = aws_route_table.CloudCart_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.CloudCart_nat_gw.id
}

resource "aws_route_table_association" "CloudCart_public_rt_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.CloudCart_subnet_public[count.index].id
  route_table_id = aws_route_table.CloudCart_public_rt.id
}

resource "aws_route_table_association" "CloudCart_private_rt_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.CloudCart_subnet_private[count.index].id
  route_table_id = aws_route_table.CloudCart_private_rt.id
}

resource "aws_route_table_association" "CloudCart_data_rt_assoc" {
  count          = length(var.data_subnet_cidrs)
  subnet_id      = aws_subnet.CloudCart_subnet_data[count.index].id
  route_table_id = aws_route_table.CloudCart_data_rt.id
}
