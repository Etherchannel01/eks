variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_endpoints" {
  description = "List of AWS services for which VPC endpoints should be created"
  type        = list(string)
  default = [
    "ec2",
    "logs", 
    "xray", 
    "elasticloadbalancing", 
    "ecr.api", 
    "ecr.dkr"
  ]
}

variable "eks_addons" {
  description = "Map of EKS addons and their configurations"
  type = map(object({
    version = string
  }))
  default = {}
}

variable "eks_scaling_config" {
  description = "EKS node group scaling configuration"
  type        = map(number)
  default = {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
}

variable "eks_update_config" {
  description = "EKS node group update configuration"
  type        = map(number)
  default = {
    max_unavailable = 1
  }
}