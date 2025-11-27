resource "aws_instance" "eks_bastion" {
  ami                         = data.aws_ami.eks_ami.id
  subnet_id                   = aws_subnet.eks_public_subnet_zone1.id
  key_name                    = "bastion"
  instance_type               = "t3.micro"
  associate_public_ip_address = "true"

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