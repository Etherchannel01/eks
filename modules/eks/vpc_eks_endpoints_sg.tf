resource "aws_security_group" "endpoints_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${local.eid}-endpoints-sg"
  }

}


resource "aws_vpc_security_group_ingress_rule" "endpoints_sg_443_ingress_rule" {
  security_group_id = aws_security_group.endpoints_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
}