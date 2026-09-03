resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.env}-alb-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.env}-app-sg"
  description = "Security group for the application tier"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.env}-app-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "data_sg" {
  name        = "${var.env}-data-sg"
  description = "Security group for the data tier (RDS, Redis)"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.env}-data-sg"
    Environment = var.env
  }
}

# --- ALB: public ingress on the two web ports ---
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 80
  to_port            = 80
  ip_protocol        = "tcp"
  description        = "Allow inbound HTTP from the internet to the ALB"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 443
  to_port            = 443
  ip_protocol        = "tcp"
  description        = "Allow inbound HTTPS from the internet to the ALB"
}

# --- ALB: egress to forward requests to the app tier ---
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  description                  = "Allow ALB to forward requests to the app tier"
}

# --- App tier: ingress only from the ALB ---
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  description                  = "Allow inbound traffic from the ALB only"
}

# --- App tier: egress only to the data tier, one rule per port ---
resource "aws_vpc_security_group_egress_rule" "app_to_postgres" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.data_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow app tier to reach RDS Postgres"
}

resource "aws_vpc_security_group_egress_rule" "app_to_redis" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.data_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Allow app tier to reach ElastiCache Redis"
}

# --- Data tier: ingress only from the app tier, one rule per port ---
resource "aws_vpc_security_group_ingress_rule" "data_postgres_from_app" {
  security_group_id            = aws_security_group.data_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow RDS Postgres access from app tier only"
}

resource "aws_vpc_security_group_ingress_rule" "data_redis_from_app" {
  security_group_id            = aws_security_group.data_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Allow ElastiCache Redis access from app tier only"
}
