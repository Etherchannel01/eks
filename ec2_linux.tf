resource "aws_instance" "eks_bastion" {
  ami                       = "ami-05ec3f7f324a54c7f"
  subnet_id                 = aws_subnet.eks_public_subnet_zone1.id
  key_name                  = "bastion"
  instance_type             = "t3.micro"
  associate_public_ip_address = "true"

  tags = {
    Name = "${local.eid}-eks-bastion"
  }
}