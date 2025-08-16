resource "aws_security_group" "eks_cluster_sg" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        Name = "${local.eid}-eks-cluster-sg"
    }
  
}




# Allow egress traffic on port 53 (DNS) for TCP within the security group
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_tcp_53_egress_rule" {
    security_group_id = aws_security_group.eks_cluster_sg.id
    from_port = 53
    to_port = 53
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

# Allow egress traffic on port 443 (HTTPS) within the security group
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_443_egress_rule" {
    security_group_id = aws_security_group.eks_cluster_sg.id
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

# Allow egress traffic on port 10250 (Kubelet API) within the security group
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_10250_egress_rule" {
    security_group_id = aws_security_group.eks_cluster_sg.id
    from_port = 10250
    to_port = 10250
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

# Allow egress traffic on port 53 (DNS) for UDP within the security group
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_udp_53_egress_rule" {
    security_group_id = aws_security_group.eks_cluster_sg.id
    from_port = 53
    to_port = 53
    ip_protocol = "udp"
    cidr_ipv4 = "0.0.0.0/0"
}
