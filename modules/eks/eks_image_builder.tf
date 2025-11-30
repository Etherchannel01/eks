# IAM role for Image Builder instance
data "aws_iam_policy_document" "image_builder_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "image_builder_instance_role" {
  assume_role_policy = data.aws_iam_policy_document.image_builder_instance_assume_role_policy.json
  name               = "${local.eid}_image_builder_instance_role"

}


# Attach required policies to the instance role
resource "aws_iam_role_policy_attachment" "image_builder_instance_profile_policy" {
  role       = aws_iam_role.image_builder_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.image_builder_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile for Image Builder
resource "aws_iam_instance_profile" "image_builder_instance_profile" {
  name = "${local.eid}_image_builder_instance_profile"
  role = aws_iam_role.image_builder_instance_role.name

  tags = {
    Name = "${local.eid}_image_builder_instance_profile"
  }
}

# Security group for Image Builder instances
resource "aws_security_group" "image_builder_sg" {
  name_prefix = "${local.eid}_image_builder_sg"
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Security group for Image Builder instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.eid}_image_builder_sg"
  }
}

# Image Builder infrastructure configuration
resource "aws_imagebuilder_infrastructure_configuration" "eks_custom_ami" {
  name                          = "${local.eid}_eks_custom_ami_infra"
  description                   = "Infrastructure configuration for EKS custom AMI"
  instance_profile_name         = aws_iam_instance_profile.image_builder_instance_profile.name
  instance_types                = ["t3.medium"]
  security_group_ids            = [aws_security_group.image_builder_sg.id]
  subnet_id                     = aws_subnet.eks_private_subnet_zone1.id
  terminate_instance_on_failure = true

  tags = {
    Name = "${local.eid}_eks_custom_ami_infra"
  }
}

# Image Builder component for customization
resource "aws_imagebuilder_component" "eks_custom_component" {
  name        = "${local.eid}_eks_custom_component"
  description = "Component for EKS custom AMI with additional software"
  platform    = "Linux"
  version     = "1.0.0"

  data = file("${path.module}/userdata/image-builder-component.yml")

  tags = {
    Name = "${local.eid}_eks_custom_component"
  }
}

# Data source to find latest EKS optimized AMI
data "aws_ami" "eks_worker_ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-x86_64-standard-1.34-v*"]
  }

  most_recent = true
  owners      = ["amazon"]
}

locals {
  block_devices = {
    "/dev/xvda" = { size = 80 } # Root volume
    "/dev/xvdf" = { size = 20 } # /var/log
    "/dev/xvdg" = { size = 20 } # /var/log/audit
    "/dev/xvdh" = { size = 20 } # /tmp
    "/dev/xvdi" = { size = 20 } # /var/tmp
  }
}

# Image Builder recipe

resource "aws_imagebuilder_image_recipe" "eks_custom_recipe" {
  name         = "${local.eid}_eks_custom_recipe"
  description  = "Recipe for EKS custom AMI based on Amazon Linux 2023"
  parent_image = data.aws_ami.eks_worker_ami.id
  version      = var.recipe_version

  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/stig-build-linux/1.0.5/1"
    parameter {
      name  = "InstallPackages"
      value = "Yes"
    }
    parameter {
      name  = "SetDoDConsentBanner"
      value = "Yes"
    }
  }

  dynamic "block_device_mapping" {
    for_each = local.block_devices
    content {
      device_name = block_device_mapping.key
      ebs {
        volume_size           = block_device_mapping.value.size
        volume_type           = "gp3"
        delete_on_termination = true
      }
    }
  }

  tags = {
    Name = "${local.eid}_eks_custom_recipe"
  }
}

# Image Builder distribution configuration
resource "aws_imagebuilder_distribution_configuration" "eks_custom_distribution" {
  name = "${local.eid}_eks_custom_distribution"

  distribution {
    ami_distribution_configuration {
      name               = "${local.eid}_eks_custom_ami-{{ imagebuilder:buildDate }}"
      description        = "Custom EKS AMI built on {{ imagebuilder:buildDate }}"
      target_account_ids = [data.aws_caller_identity.current.account_id]

      ami_tags = {
        Name      = "${local.eid}_eks_custom_ami"
        Type      = "EKS-Custom"
        BaseImage = "Amazon-Linux-2023"
      }
    }
    region = data.aws_region.current.region
  }

  tags = {
    Name = "${local.eid}_eks_custom_distribution"
  }
}

# Image Builder pipeline
resource "aws_imagebuilder_image_pipeline" "eks_custom_pipeline" {
  name                             = "${local.eid}_eks_custom_pipeline"
  description                      = "Pipeline for building EKS custom AMI"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.eks_custom_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.eks_custom_ami.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.eks_custom_distribution.arn
  status                           = "ENABLED"

  schedule {
    schedule_expression                = "cron(0 8 1-7 ? 7 *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

  image_tests_configuration {
    image_tests_enabled = true
    timeout_minutes     = 720
  }

  tags = {
    Name = "${local.eid}_eks_custom_pipeline"
  }
}

# Run a build immediately (one-time) using the same recipe/infra/distribution
resource "aws_imagebuilder_image" "eks_custom_image" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.eks_custom_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.eks_custom_ami.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.eks_custom_distribution.arn

  depends_on = [aws_imagebuilder_image_pipeline.eks_custom_pipeline]

  tags = {
    Name = "${local.eid}_eks_custom_image_build"
  }
}
# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Outputs
output "image_builder_pipeline_arn" {
  description = "ARN of the Image Builder pipeline"
  value       = aws_imagebuilder_image_pipeline.eks_custom_pipeline.arn
}

output "image_builder_recipe_arn" {
  description = "ARN of the Image Builder recipe"
  value       = aws_imagebuilder_image_recipe.eks_custom_recipe.arn
}
