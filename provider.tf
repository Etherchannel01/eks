terraform {
  required_version = "1.9.3"
  
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "5.62.0"
	}
  }
}

provider "aws" {
  region = "us-east-1"

  # default_tags {
  #   tags = {
  #     Environment = var.environment
  #   }
  # }
}