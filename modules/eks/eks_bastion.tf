resource "aws_instance" "eks_bastion" {
  ami                         = data.aws_ami.eks_ami.id
  subnet_id                   = aws_subnet.eks_public_subnet_zone1.id
  key_name                    = "bastion"
  instance_type               = "t3.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  user_data_base64 = base64encode(templatefile("${path.module}/userdata/user_data.tpl", {
    cluster_name          = local.cluster_name
    api_server_endpoint   = local.api_server_endpoint
    certificate_authority = local.certificate_authority
    cidr_block            = local.cidr_block
  }))

  tags = {
    Name = "${local.eid}-eks-bastion"
  }
}

resource "aws_security_group" "bastion_sg" {
  name = "${local.eid}-bastion-sg"
  description = "Security group for EKS bastion host"
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${local.eid}-bastion-sg"
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_22_ssh_ingress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "170.64.110.165/32"
  
}

resource "aws_vpc_security_group_egress_rule" "allow_tcp_443_https_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  
}