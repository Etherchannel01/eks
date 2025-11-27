resource "aws_subnet" "eks_private_subnet_zone1" {
    vpc_id     = aws_vpc.eks_vpc.id
    cidr_block = local.eks_cidr_subnet_zone1
    availability_zone = local.availability_zones[0]
    map_public_ip_on_launch = false
    tags = {
        Name = "${local.eid}-eks-private-subnet-zone1"
        "kubernetes.io/role/internal-elb" = "1"
    }
  
}

resource "aws_subnet" "eks_private_subnet_zone2" {
    vpc_id     = aws_vpc.eks_vpc.id
    cidr_block = local.eks_cidr_subnet_zone2
    availability_zone = local.availability_zones[1]
    map_public_ip_on_launch = false
    tags = {
        Name = "${local.eid}-eks-private-subnet-zone2"
        "kubernetes.io/role/internal-elb" = "1"
    }
  
}

resource "aws_subnet" "eks_private_subnet_zone3" {
    vpc_id     = aws_vpc.eks_vpc.id
    cidr_block = local.eks_cidr_subnet_zone3
    availability_zone = local.availability_zones[2]
    map_public_ip_on_launch = false
    tags = {
        Name = "${local.eid}-eks-private-subnet-zone3"
        "kubernetes.io/role/internal-elb" = "1"
    }
  
}

