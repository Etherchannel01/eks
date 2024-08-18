resource "aws_eks_cluster" "eks_cluster" {
    name     = "${local.eid}-eks-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    vpc_config {
        #security_group_ids = [aws_security_group.eks_cluster_sg.id]
        subnet_ids         = [
        aws_subnet.eks_private_subnet_zone1.id,
        aws_subnet.eks_private_subnet_zone2.id,
        aws_subnet.eks_private_subnet_zone3.id
        ]
        endpoint_private_access = true
    }
    version = var.eks_version
    tags = {
        Name = "${local.eid}-eks-cluster"
    }

    depends_on = [ 
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_vpc_endpoint.endpoints
    ]
  
}

resource "aws_eks_node_group" "eks_node_group" {
    cluster_name    = aws_eks_cluster.eks_cluster.name
    node_group_name = "${local.eid}-eks-node-group"
    node_role_arn   = aws_iam_role.eks_node_group_role.arn
    subnet_ids      = [
    aws_subnet.eks_private_subnet_zone1.id,
    aws_subnet.eks_private_subnet_zone2.id,
    aws_subnet.eks_private_subnet_zone3.id
    ]
    
    instance_types  = [ local.instance_types ]
    
    scaling_config {
    desired_size = local.scaling_config["desired_size"]
    max_size     = local.scaling_config["max_size"]
    min_size     = local.scaling_config["min_size"]
  }

  update_config {
    max_unavailable = local.update_config["max_unavailable"]
  }
    depends_on = [ aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_vpc_endpoint.endpoints
    ]

    tags = {        
        Name = "${local.eid}-eks-node-group"
        "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
    }
  
}


# resource "aws_eks_addon" "eks_addons" {
#     for_each = toset(var.eks_addons)
#     cluster_name = aws_eks_cluster.eks_cluster.name
#     addon_name   = "${each.value}"
#     depends_on = [aws_eks_cluster.eks_cluster]
#     resolve_conflicts_on_update = "OVERWRITE"
  
# }