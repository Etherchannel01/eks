data "aws_ami" "eks_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${local.eid}_eks_custom_ami*"]
  }
  depends_on = [aws_imagebuilder_image_pipeline.eks_custom_pipeline]

}

resource "aws_launch_template" "eks_node_launch_template" {

  name_prefix   = "${local.eid}_eks_node_launch_template"
  image_id      = data.aws_ami.eks_ami.id
  instance_type = local.instance_types
  user_data = base64encode(templatefile("${path.module}/userdata/template.tpl", {
    cluster_name          = local.cluster_name
    api_server_endpoint   = local.api_server_endpoint
    certificate_authority = local.certificate_authority
    cidr_block            = local.cidr_block
  }))

  key_name = "bastion"


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.eid}_eks_node"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [data.aws_ami.eks_ami]
}