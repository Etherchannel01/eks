output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = data.aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "vpc_id" {
  description = "VPC ID where EKS cluster is deployed"
  value       = aws_vpc.eks_vpc.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.eks_private_subnet_zone1.id,
    aws_subnet.eks_private_subnet_zone2.id,
    aws_subnet.eks_private_subnet_zone3.id
  ]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    aws_subnet.eks_public_subnet_zone1.id,
    aws_subnet.eks_public_subnet_zone2.id,
    aws_subnet.eks_public_subnet_zone3.id
  ]
}