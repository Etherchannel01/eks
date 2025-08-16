resource "aws_launch_template" "eks_node_launch_template" {

    name_prefix   = "${local.eid}-eks-node-launch-template"
    image_id      = "ami-05ec3f7f324a54c7f"
    instance_type = local.instance_types
    user_data     = base64encode(templatefile("${path.module}/user_data.tpl", {
        cluster_name          = local.cluster_name
        api_server_endpoint   = local.api_server_endpoint
        certificate_authority = local.certificate_authority
        cidr_block            = local.cidr_block
    }))
    
    # key_name = "eks-keypair"
    
    #vpc_security_group_ids = [aws_security_group.eks_node_sg.id]
    
    
    tag_specifications {
        resource_type = "instance"
        tags = {
        Name = "${local.eid}-eks-node"
        }
    }
    
    lifecycle {
        create_before_destroy = true
    }
  
}