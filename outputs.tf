output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.eks_cluster_arn
}

output "vpc_id" {
  description = "VPC ID where EKS cluster is deployed"
  value       = module.eks.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.eks.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.eks.public_subnet_ids
}