# IAM role for Image Builder instance
resource "aws_iam_role" "image_builder_instance_role" {
  name = "${local.eid}-image-builder-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${local.eid}-image-builder-instance-role"
  }
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
  name = "${local.eid}-image-builder-instance-profile"
  role = aws_iam_role.image_builder_instance_role.name

  tags = {
    Name = "${local.eid}-image-builder-instance-profile"
  }
}

# Security group for Image Builder instances
resource "aws_security_group" "image_builder_sg" {
  name_prefix = "${local.eid}-image-builder-"
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Security group for Image Builder instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.eid}-image-builder-sg"
  }
}

# Image Builder infrastructure configuration
resource "aws_imagebuilder_infrastructure_configuration" "eks_custom_ami" {
  name                          = "${local.eid}-eks-custom-ami-infra"
  description                   = "Infrastructure configuration for EKS custom AMI"
  instance_profile_name         = aws_iam_instance_profile.image_builder_instance_profile.name
  instance_types                = ["t3.medium"]
  security_group_ids            = [aws_security_group.image_builder_sg.id]
  subnet_id                     = aws_subnet.eks_private_subnet_zone1.id
  terminate_instance_on_failure = true

  tags = {
    Name = "${local.eid}-eks-custom-ami-infra"
  }
}

# Image Builder component for customization
resource "aws_imagebuilder_component" "eks_custom_component" {
  name        = "${local.eid}-eks-custom-component"
  description = "Component for EKS custom AMI with additional software"
  platform    = "Linux"
  version     = "1.0.0"

  data = file("${path.module}/image-builder-component.yml")

  tags = {
    Name = "${local.eid}-eks-custom-component"
  }
}

# Data source to find latest EKS optimized AMI
data "aws_ami" "eks_worker_ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-x86_64-standard-1.33-v*"]
  }

  most_recent = true
  owners      = ["amazon"]
}

# Image Builder recipe
resource "aws_imagebuilder_image_recipe" "eks_custom_recipe" {
  name         = "${local.eid}-eks-custom-recipe"
  description  = "Recipe for EKS custom AMI based on Amazon Linux 2023"
  parent_image = data.aws_ami.eks_worker_ami.id
  version      = "1.0.0"

  component {
    component_arn = aws_imagebuilder_component.eks_custom_component.arn
  }

  block_device_mapping {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
    }
  }

  tags = {
    Name = "${local.eid}-eks-custom-recipe"
  }
}

# Image Builder distribution configuration
resource "aws_imagebuilder_distribution_configuration" "eks_custom_distribution" {
  name = "${local.eid}-eks-custom-distribution"

  distribution {
    ami_distribution_configuration {
      name               = "${local.eid}-eks-custom-ami-{{ imagebuilder:buildDate }}"
      description        = "Custom EKS AMI built on {{ imagebuilder:buildDate }}"
      target_account_ids = [data.aws_caller_identity.current.account_id]

      ami_tags = {
        Name      = "${local.eid}-eks-custom-ami"
        Type      = "EKS-Custom"
        BaseImage = "Amazon-Linux-2023"
      }
    }
    region = data.aws_region.current.name
  }

  tags = {
    Name = "${local.eid}-eks-custom-distribution"
  }
}

# Image Builder pipeline
resource "aws_imagebuilder_image_pipeline" "eks_custom_pipeline" {
  name                              = "${local.eid}-eks-custom-pipeline"
  description                       = "Pipeline for building EKS custom AMI"
  image_recipe_arn                  = aws_imagebuilder_image_recipe.eks_custom_recipe.arn
  infrastructure_configuration_arn  = aws_imagebuilder_infrastructure_configuration.eks_custom_ami.arn
  distribution_configuration_arn    = aws_imagebuilder_distribution_configuration.eks_custom_distribution.arn
  status                            = "ENABLED"

  schedule {
    schedule_expression                 = "cron(0 8 1-7 ? 7 *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

  image_tests_configuration {
    image_tests_enabled = true
    timeout_minutes     = 720
  }

  tags = {
    Name = "${local.eid}-eks-custom-pipeline"
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
