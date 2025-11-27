resource "aws_nat_gateway" "eks_nat_gateway_z1" {
    allocation_id = aws_eip.eks_eip_z1.id
    subnet_id     = aws_subnet.eks_public_subnet_zone1.id
    private_ip    = local.eks_nat_gateway_ip_zone1
    
    tags          = {
        Name      = "${local.eid}-eks-nat-gateway-z1"
    }
    
    depends_on    = [ aws_internet_gateway.eks_igw ]
}

resource "aws_nat_gateway" "eks_nat_gateway_z2" {
    allocation_id = aws_eip.eks_eip_z2.id
    subnet_id     = aws_subnet.eks_public_subnet_zone2.id
    private_ip    = local.eks_nat_gateway_ip_zone2
    
    tags          = {
        Name      = "${local.eid}-eks-nat-gateway-z2"
    }
    
    depends_on    = [ aws_internet_gateway.eks_igw ]
}

resource "aws_nat_gateway" "eks_nat_gateway_z3" {
    allocation_id = aws_eip.eks_eip_z3.id
    subnet_id     = aws_subnet.eks_public_subnet_zone3.id
    private_ip    = local.eks_nat_gateway_ip_zone3
    
    tags          = {
        Name      = "${local.eid}-eks-nat-gateway-z3"
    }
    
    depends_on = [ aws_internet_gateway.eks_igw ]
}