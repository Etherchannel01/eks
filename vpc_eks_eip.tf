resource "aws_eip" "eks_eip_z1" {
    tags = {
        Name = "${local.eid}-eks-eip-z1"
    }
  
}

resource "aws_eip" "eks_eip_z2" {
    tags = {
        Name = "${local.eid}-eks-eip-z2"
    }
  
}

resource "aws_eip" "eks_eip_z3" {
    tags = {
        Name = "${local.eid}-eks-eip-z3"
    }
  
}