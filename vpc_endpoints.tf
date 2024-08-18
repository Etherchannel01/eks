resource "aws_vpc_endpoint" "endpoints" {
    for_each = toset(var.vpc_endpoints)
    vpc_id = aws_vpc.eks_vpc.id
    service_name = "com.amazonaws.${var.region}.${each.value}"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [aws_security_group.endpoints_sg.id]

    subnet_ids = [
        aws_subnet.eks_private_subnet_zone1.id,
        aws_subnet.eks_private_subnet_zone2.id,
        aws_subnet.eks_private_subnet_zone3.id
      
    ]

    tags = {
        Name = "${local.eid}-vpc-endpoint-${each.value}"
    }
  
}