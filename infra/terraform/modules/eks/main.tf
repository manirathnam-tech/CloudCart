resource "aws_iam_role" "eks_control_plane_role" {
  name = "${var.env}-eks-control-plane-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
 
resource "aws_iam_role_policy_attachment" "eks_control_plane_policy" {
  role       = aws_iam_role.eks_control_plane_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
 
resource "aws_security_group" "eks_sg" {
 
  name        = "${var.env}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
 
  tags = {
    Name        = "${var.env}-eks-sg"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_egress_rule" "eks_sg_all_out" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol        = "-1"
  description        = "Allow all outbound - API calls, ECR image pulls, etc."
}

resource "aws_vpc_security_group_ingress_rule" "eks_sg_self_all" {
  security_group_id            = aws_security_group.eks_sg.id
  referenced_security_group_id = aws_security_group.eks_sg.id
  ip_protocol                  = "-1"
  description                  = "Allow all traffic between control plane and nodes sharing this SG"
 }
resource "aws_eks_cluster" "this" {
 
  name     = "${var.env}-eks-cluster"
  role_arn = aws_iam_role.eks_control_plane_role.arn
  version  = "1.36"
 
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eks_public_access_cidrs
  }
 
  tags = {
    Name        = "${var.env}-eks-cluster"
    Environment = var.env
  }
 
  depends_on = [aws_iam_role_policy_attachment.eks_control_plane_policy]
}
