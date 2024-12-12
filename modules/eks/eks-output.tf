output "eks_cluster_info" {
  value = {
    eks_cluster_name                       = module.eks.cluster_name
    eks_cluster_endpoint                   = module.eks.cluster_endpoint
    eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}
