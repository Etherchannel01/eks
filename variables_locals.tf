locals {


availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

eid = substr(var.environment, 0, 1)
  
## EKS Private Subnets    

eks_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 8, 0)  ## 10.0.0.0/24   Usable IP addresses 10.0.0.4 - 10.0.0.254

eks_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 8, 1)  ## 10.0.1.0/24   Usable IP addresses 10.0.1.4 - 10.0.1.254

eks_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 8, 2)  ## 10.0.2.0/24   Usable IP addresses 10.0.2.4 - 10.0.2.254


## EKS Public Subnets

eks_public_cidr_subnet_zone1 = cidrsubnet(var.vpc_cidr, 12, 48)  ## 10.0.3.0/28    Usable IP addresses 10.0.3.4 - 10.0.3.14

eks_public_cidr_subnet_zone2 = cidrsubnet(var.vpc_cidr, 12, 49)  ## 10.0.3.16/28   Usable IP addresses 10.0.3.21 - 10.0.3.30

eks_public_cidr_subnet_zone3 = cidrsubnet(var.vpc_cidr, 12, 50)  ## 10.0.3.32/28   Usable IP addresses 10.0.3.37 - 10.0.3.46



## EKS NAT Gateway IP Addresses

eks_nat_gateway_ip_zone1 = cidrhost(cidrsubnet(var.vpc_cidr, 12, 48), 14)  ## 10.0.3.14

eks_nat_gateway_ip_zone2 = cidrhost(cidrsubnet(var.vpc_cidr, 12, 49), 14)  ## 10.0.3.30

eks_nat_gateway_ip_zone3 = cidrhost(cidrsubnet(var.vpc_cidr, 12, 50), 14)  ## 10.0.3.46



   
}