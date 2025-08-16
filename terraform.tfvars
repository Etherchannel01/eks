#############################################################################################################
#                                             DEFAULT AWS VALUES                                           #
#############################################################################################################

region   = "us-east-1"

vpc_cidr = "10.0.0.0/16"

environment = "development"













#############################################################################################################
#                                              EKS CONFIGURATION                                           #
#############################################################################################################
eks_version = "1.33"

eks_scaling_config = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
}

eks_update_config = {
    max_unavailable = 1
}

# eks_addons = [
#         "vpc-cni",
#         # "kube-proxy",
#         # "aws-ebs-csi-driver",
#         # "aws-efs-csi-driver",
#         # "aws-mountpoint-s3-csi-driver",
#         # "aws-guardduty-agent",
#         # "amazon-cloudwatch-observability",
#         # "eks-pod-identity-agent"
# ]

eks_addons = {
  vpc-cni = {
    version = "v1.20.1-eksbuild.1"
  }    
}


