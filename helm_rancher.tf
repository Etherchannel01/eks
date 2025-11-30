# resource "helm_release" "rancher" {
#     name       = "rancher"
#     repository = "https://releases.rancher.com/server-charts/latest"
#     chart      = "rancher"
#     namespace  = "cattle-system"
    
#     set = [ 
#     {
#         name  = "hostname"
#         value = var.rancher_hostname
#     },
#         {
#         name  = "ingress.enabled"
#         value = "false"
#     },

#     {
#         name  = "ingress.tls.source"
#         value = "letsEncrypt"
#     },

#     {
#         name  = "letsEncrypt.email"
#         value = var.lets_encrypt_email
#     },

#     {
#         name  = "letsEncrypt.environment"
#         value = var.lets_encrypt_environment
#     }
# ]
    
#     depends_on = [module.eks]
  
# }

# resource "helm_release" "load_balancer_controller" {
#     name       = "aws-load-balancer-controller"
#     repository = "https://aws.github.io/eks-charts"
#     chart      = "aws-load-balancer-controller"
#     namespace  = "kube-system"
    
#     set = [ 
#     {
#         name  = "clusterName"
#         value = module.eks.eks_cluster_name
#     },
#         {
#         name  = "serviceAccount.create"
#         value = "false"
#     },

#     {
#         name  = "serviceAccount.name"
#         value = "aws-load-balancer-controller"
#     },
#     {
#         name = "version"
#         value = "v1.16.0"
#     }
# ]
    
#     depends_on = [module.eks]
  
# }