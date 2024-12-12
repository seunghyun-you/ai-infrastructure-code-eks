module "sg_ap_endpoints" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name        = var.security_group_config["endpoint"].sg_name
  vpc_id      = var.security_group_config["endpoint"].vpc_id
  description = var.security_group_config["endpoint"].description

  ingress_with_cidr_blocks = var.security_group_config["endpoint"].ingress_rule
  egress_rules             = var.security_group_config["endpoint"].common_egress_rule

}

module "sg_ap_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name        = var.security_group_config["ec2_bastion"].sg_name
  vpc_id      = var.security_group_config["ec2_bastion"].vpc_id
  description = var.security_group_config["ec2_bastion"].description

  ingress_with_cidr_blocks = var.security_group_config["ec2_bastion"].ingress_rule
  egress_rules             = var.security_group_config["ec2_bastion"].common_egress_rule
}

module "sg_ap_eks_workspace" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name        = var.security_group_config["ec2_eks_workspace"].sg_name
  vpc_id      = var.security_group_config["ec2_eks_workspace"].vpc_id
  description = var.security_group_config["ec2_eks_workspace"].description

  ingress_with_cidr_blocks = var.security_group_config["ec2_eks_workspace"].ingress_rule
  egress_rules             = var.security_group_config["ec2_eks_workspace"].common_egress_rule
}

module "sg_ap_eks_cluster" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name        = var.security_group_config["ec2_eks_cluster"].sg_name
  vpc_id      = var.security_group_config["ec2_eks_cluster"].vpc_id
  description = var.security_group_config["ec2_eks_cluster"].description

  ingress_with_cidr_blocks = var.security_group_config["ec2_eks_cluster"].ingress_rule
  egress_rules             = var.security_group_config["ec2_eks_cluster"].common_egress_rule
}
