module "iam_ec2_bastion_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name = var.iam_role_config["bastion_role"].role_name

  create_role             = var.iam_role_config["bastion_role"].create_role
  create_instance_profile = var.iam_role_config["bastion_role"].create_instance_profile
  role_requires_mfa       = var.iam_role_config["bastion_role"].role_requires_mfa

  trusted_role_actions  = var.iam_role_config["bastion_role"].trusted_role_actions
  trusted_role_services = var.iam_role_config["bastion_role"].trusted_role_services

  attach_admin_policy     = var.iam_role_config["bastion_role"].attach_admin_policy
  attach_poweruser_policy = var.iam_role_config["bastion_role"].attach_poweruser_policy
  custom_role_policy_arns = var.iam_role_config["bastion_role"].custom_role_policy_arns
}

module "iam_eks_workspace_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name = var.iam_role_config["eks_workspace_role"].role_name

  create_role             = var.iam_role_config["eks_workspace_role"].create_role
  create_instance_profile = var.iam_role_config["eks_workspace_role"].create_instance_profile
  role_requires_mfa       = var.iam_role_config["eks_workspace_role"].role_requires_mfa

  trusted_role_actions  = var.iam_role_config["eks_workspace_role"].trusted_role_actions
  trusted_role_services = var.iam_role_config["eks_workspace_role"].trusted_role_services

  attach_admin_policy     = var.iam_role_config["eks_workspace_role"].attach_admin_policy
  attach_poweruser_policy = var.iam_role_config["eks_workspace_role"].attach_poweruser_policy
  custom_role_policy_arns = var.iam_role_config["eks_workspace_role"].custom_role_policy_arns
}
