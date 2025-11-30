variable "region" {
  description = "AWS region"
  type        = string
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "eks_version" {
  description = "EKS version"
  type        = string
}

variable "recipe_version" {
  description = "Version of the EKS custom AMI recipe"
  type        = string
}

variable "vpc_endpoints" {
  description = "List of AWS services for which VPC endpoints should be created."
  type        = list(string)
  default = [
    "ec2",
    "logs",
    "xray",
    "elasticloadbalancing",
    "ecr.api",
    "ecr.dkr",
    "eks",
    "eks-auth"
  ]
}

variable "eks_addons" {
  description = "Map of EKS addons and their configurations"
  type = map(object({
    version = string
  }))
  default = {
  }
}


variable "eks_scaling_config" {
  description = "EKS scaling configuration"
  type        = map(number)
  default     = {}

}

variable "eks_update_config" {
  description = "EKS update configuration"
  type        = map(number)
  default     = {}

}
