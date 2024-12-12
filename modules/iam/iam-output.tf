output "iam_role_ids" {
  value = {
    ec2_bastion_role_id        = module.iam_ec2_bastion_role.iam_instance_profile_name
    ec2_eks_workspace_role_id  = module.iam_eks_workspace_role.iam_instance_profile_name
    ec2_eks_workspace_role_arn = module.iam_eks_workspace_role.iam_role_arn
  }
}
