resource "aws_eks_access_entry" "access" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = "arn:aws:iam::290226690004:user/nicholas.hill"
  type              = "STANDARD"
}


resource "aws_eks_access_policy_association" "AmazonEKSAdminPolicy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = "arn:aws:iam::290226690004:user/nicholas.hill"

  access_scope {
    type       = "cluster"
  }
}