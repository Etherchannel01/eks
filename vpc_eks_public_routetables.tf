resource "aws_route_table" "eks_public_rt_z1" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      Name = "${local.eid}-eks-public-rt-z1"
    }

  
}

resource "aws_route_table" "eks_public_rt_z2" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      Name = "${local.eid}-eks-public-rt-z2"
    }

    

  
}

resource "aws_route_table" "eks_public_rt_z3" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      Name = "${local.eid}-eks-public-rt-z3"
    }

  
}


resource "aws_route_table_association" "eks_public_subnet_association_z1" {
    subnet_id      = aws_subnet.eks_public_subnet_zone1.id
    route_table_id = aws_route_table.eks_public_rt_z1.id
    
}


resource "aws_route_table_association" "eks_public_subnet_association_z2" {
    subnet_id      = aws_subnet.eks_public_subnet_zone2.id
    route_table_id = aws_route_table.eks_public_rt_z2.id
}


resource "aws_route_table_association" "eks_public_subnet_association_z3" {
    subnet_id      = aws_subnet.eks_public_subnet_zone3.id
    route_table_id = aws_route_table.eks_public_rt_z3.id
}


resource "aws_route" "public_r1" {
    route_table_id = aws_route_table.eks_public_rt_z1.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  
}

resource "aws_route" "public_r2" {
    route_table_id = aws_route_table.eks_public_rt_z2.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id 
}

resource "aws_route" "public_r3" {
    route_table_id = aws_route_table.eks_public_rt_z3.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
}
