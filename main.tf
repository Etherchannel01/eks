module "eks" {
  source = "./modules/eks"

  region             = var.region
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  eks_version        = var.eks_version
  vpc_endpoints      = var.vpc_endpoints
  eks_addons         = var.eks_addons
  eks_scaling_config = var.eks_scaling_config
  eks_update_config  = var.eks_update_config
}