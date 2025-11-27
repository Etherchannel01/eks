resource "aws_ecr_repository" "eks_ecr" {
  name                 = "${local.eid}-eks-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}