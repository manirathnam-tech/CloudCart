data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "ssm_test_sg" {
  name        = "${var.env}-ssm-test-sg"
  description = "Temporary SG for CC-11 SSM connectivity validation - no ingress, HTTPS egress only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.env}-ssm-test-sg"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_egress_rule" "ssm_test_https_out" {
  security_group_id = aws_security_group.ssm_test_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 443
  to_port            = 443
  ip_protocol        = "tcp"
  description        = "Allow HTTPS out so the SSM agent can connect and curl can reach an external API"
}

resource "aws_iam_role" "ssm_role" {
  name = "${var.env}-ssm-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.env}-ssm-role"
    Environment = var.env
  }
}

resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.env}-ssm-test-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "ssm_test_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ssm_test_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name        = "${var.env}-ssm-test-instance"
    Environment = var.env
    Purpose     = "CC-11 throwaway network validation - destroy after use"
  }
}
