output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "The name of the EKS cluster"
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "The ARN of the EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "The API server endpoint for the EKS cluster"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Base64-encoded certificate authority data for the cluster"
  sensitive   = true
}

output "cluster_security_group_id" {
  value       = aws_security_group.eks_sg.id
  description = "The dedicated security group attached to the control plane"
}

output "cluster_iam_role_arn" {
  value       = aws_iam_role.eks_control_plane_role.arn
  description = "The IAM role ARN the EKS control plane assumes"
}
