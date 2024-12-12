output "sg_ids" {
  value = {
    endpoint_sg_id          = module.sg_ap_endpoints.security_group_id
    ec2_bastion_sg_id       = module.sg_ap_bastion.security_group_id
    ec2_eks_workspace_sg_id = module.sg_ap_eks_workspace.security_group_id
    ec2_eks_cluster_sg_id   = module.sg_ap_eks_cluster.security_group_id
  }
}
