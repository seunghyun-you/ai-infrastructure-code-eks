module "vpc_ap" {
  source = "./modules/vpc"

  resource_name  = local.network_resource_name
  vpc_config     = var.vpc_config
  azs_config     = local.availability_zones
  subnets_config = var.subnets_config
}

module "vpc_endpoints_ap" {
  source = "./modules/vpc_endpoint"

  vpc_endpoint_configs = local.vpc_endpoint_configs
}

module "security_group_ap" {
  source = "./modules/security_group"

  security_group_config = local.security_group_config
}

module "ec2_ap" {
  source = "./modules/ec2"

  key_pair_config = local.key_pair_config
  ec2_config      = local.ec2_config
}

module "eks_ap" {
  source = "./modules/eks"

  eks_config = local.eks_config
}

module "iam" {
  source = "./modules/iam"

  iam_role_config = local.iam_config
}
