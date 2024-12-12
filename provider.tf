# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

# provider "kubernetes" {
#   config_path    = "~/.kube/config"
# }
provider "kubernetes" {
  host                   = module.eks_ap.eks_cluster_info.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_ap.eks_cluster_info.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.default.token
}

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }
provider "helm" {
  kubernetes {
    host                   = module.eks_ap.eks_cluster_info.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_ap.eks_cluster_info.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}
