variable "region" {
    description = "AWS region"
    type = string
    default = ""
  
}


variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default = ""
  
}

variable "environment" {
    description = "Environment"
    type = string
    default = ""
  
}

variable "eks_version" {
    description = "EKS version"
    type = string
    default = ""
  
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
    "ecr.dkr"
  ]
}

variable "eks_addons" { 
    description = "List of EKS addons to install"
    type        = list(string)
    default = [
        "vpc-cni",
        "kube-proxy",
        "aws-ebs-csi-driver",
        "aws-efs-csi-driver",
        "aws-mountpoint-s3-csi-driver",
        "aws-guardduty-agent",
        "amazon-cloudwatch-observability",
        "eks-pod-identity-agent"
    ]
  
}