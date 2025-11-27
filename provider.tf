terraform {
  required_version = ">= 1.0.0"

  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "6.9.0"
	}
  }
}

provider "aws" {
  region = var.region
}

# provider "helm" {
#   kubernetes {
#     host                   = var.kubernetes_host
#     cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
#     token                  = var.kubernetes_token
#   }
# }

# provider "rancher" {
  
#}