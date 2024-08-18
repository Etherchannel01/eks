locals {


availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

eid = substr(var.environment, 0, 1)


## EKS Cluster Configuration

instance_types = "t3.medium"

scaling_config = var.eks_scaling_config

update_config  = var.eks_update_config

eks_addons     = var.eks_addons







## EKS Private Subnets    

eks_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 8, 0)  ## 10.0.0.0/24   Usable IP addresses 10.0.0.5 - 10.0.0.254

eks_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 8, 1)  ## 10.0.1.0/24   Usable IP addresses 10.0.1.5 - 10.0.1.254

eks_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 8, 2)  ## 10.0.2.0/24   Usable IP addresses 10.0.2.5 - 10.0.2.254


## EKS Public Subnets

eks_public_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 8, 3)  ## 10.0.3.0/24    Usable IP addresses 10.0.3.5 - 10.0.3.254

eks_public_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 8, 4)  ## 10.0.4.0/24   Usable IP addresses 10.0.4.5 - 10.0.4.254

eks_public_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 8, 5)  ## 10.0.5.0/24   Usable IP addresses 10.0.5.5 - 10.0.5.254



## EKS NAT Gateway IP Addresses

eks_nat_gateway_ip_zone1 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 3), 254)  ## 10.0.3.254

eks_nat_gateway_ip_zone2 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 4), 254)  ## 10.0.4.254

eks_nat_gateway_ip_zone3 = cidrhost(cidrsubnet(var.vpc_cidr, 8, 5), 254)  ## 10.0.5.254



   
}