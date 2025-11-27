locals {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  eid                = substr(var.environment, 0, 1)

  # EKS Cluster Configuration
  instance_types = "t3.medium"
  scaling_config = var.eks_scaling_config
  update_config  = var.eks_update_config
  eks_addons     = var.eks_addons

  # EKS Private Subnets    
  eks_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 8, 0)
  eks_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 8, 1)
  eks_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 8, 2)

  # EKS Public Subnets
  eks_public_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 8, 3)
  eks_public_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 8, 4)
  eks_public_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 8, 5)

  # EKS NAT Gateway IP Addresses
  eks_nat_gateway_ip_zone1 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 3), 254)
  eks_nat_gateway_ip_zone2 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 4), 254)
  eks_nat_gateway_ip_zone3 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 5), 254)
}

locals {
  cluster_name          = aws_eks_cluster.eks_cluster.name
  api_server_endpoint   = data.aws_eks_cluster.eks_cluster.endpoint
  certificate_authority = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
  cidr_block            = data.aws_eks_cluster.eks_cluster.kubernetes_network_config[0].service_ipv4_cidr
}