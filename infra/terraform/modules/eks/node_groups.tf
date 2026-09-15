resource "aws_iam_role" "eks_node_role" {
  name = "${var.env}-eks-node-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
 
resource "aws_iam_role_policy_attachment" "eks_node_worker_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
 
resource "aws_iam_role_policy_attachment" "eks_node_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
 
resource "aws_iam_role_policy_attachment" "eks_node_ecr_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
 
data "aws_ssm_parameter" "eks_optimized_ami" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.this.version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}
 
resource "aws_launch_template" "eks_system" {
  name_prefix            = "${var.env}-eks-system-"
  image_id               = data.aws_ssm_parameter.eks_optimized_ami.value
  instance_type          = "t3.medium"
  update_default_version = true
 

  user_data = base64encode(<<-EOT
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="BOUNDARY"
 
    --BOUNDARY
    Content-Type: application/node.eks.aws
 
    apiVersion: node.eks.aws/v1alpha1
    kind: NodeConfig
    spec:
      cluster:
        name: ${aws_eks_cluster.this.name}
        apiServerEndpoint: ${aws_eks_cluster.this.endpoint}
        certificateAuthority: ${aws_eks_cluster.this.certificate_authority[0].data}
        cidr: ${aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr}
 
    --BOUNDARY--
  EOT
  )
 
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}
 
resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.env}-system"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  capacity_type   = "ON_DEMAND"
 
  launch_template {
    id      = aws_launch_template.eks_system.id
    version = aws_launch_template.eks_system.latest_version
  }
 
  labels = {
    node_role = "system"
  }
 
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }
 
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker_policy,
    aws_iam_role_policy_attachment.eks_node_cni_policy,
    aws_iam_role_policy_attachment.eks_node_ecr_policy
  ]
}
 
 resource "aws_eks_node_group" "workloads" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.env}-workloads"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["t3.large"]

  ami_type      = "AL2023_x86_64_STANDARD"
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker_policy,
    aws_iam_role_policy_attachment.eks_node_cni_policy,
    aws_iam_role_policy_attachment.eks_node_ecr_policy
  ]
}
