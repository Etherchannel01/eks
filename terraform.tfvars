#############################################################################################################
#                                             DEFAULT AWS VALUES                                           #
#############################################################################################################

region   = "us-east-1"

vpc_cidr = "10.0.0.0/16"

environment = "development"













#############################################################################################################
#                                              EKS CONFIGURATION                                           #
#############################################################################################################
eks_version = "1.30"

eks_scaling_config = {
    desired_size = 2
    max_size     = 2
    min_size     = 1
}

eks_update_config = {
    max_unavailable = 1
}

eks_addons = [
        "vpc-cni",
        "kube-proxy",
        "aws-ebs-csi-driver",
        "aws-efs-csi-driver",
        "aws-mountpoint-s3-csi-driver",
        "aws-guardduty-agent",
        "amazon-cloudwatch-observability",
        "eks-pod-identity-agent"
]



