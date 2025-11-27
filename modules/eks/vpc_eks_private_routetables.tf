resource "aws_route_table" "eks_private_rt_z1" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${local.eid}-eks-private-rt-z1"
  }


}

resource "aws_route_table" "eks_private_rt_z2" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${local.eid}-eks-private-rt-z2"
  }



}

resource "aws_route_table" "eks_private_rt_z3" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${local.eid}-eks-private-rt-z3"
  }


}

resource "aws_route_table_association" "eks_private_subnet_association_z1" {
  subnet_id      = aws_subnet.eks_private_subnet_zone1.id
  route_table_id = aws_route_table.eks_private_rt_z1.id

}

resource "aws_route_table_association" "eks_private_subnet_association_z2" {
  subnet_id      = aws_subnet.eks_private_subnet_zone2.id
  route_table_id = aws_route_table.eks_private_rt_z2.id

}

resource "aws_route_table_association" "eks_private_subnet_association_z3" {
  subnet_id      = aws_subnet.eks_private_subnet_zone3.id
  route_table_id = aws_route_table.eks_private_rt_z3.id

}

resource "aws_route" "private_r1" {
  route_table_id         = aws_route_table.eks_private_rt_z1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_z1.id

}

resource "aws_route" "private_r2" {
  route_table_id         = aws_route_table.eks_private_rt_z2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_z2.id

}

resource "aws_route" "private_r3" {
  route_table_id         = aws_route_table.eks_private_rt_z3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_z3.id
}

