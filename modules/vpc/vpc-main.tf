module "ap_northeast_2" {
  source = "terraform-aws-modules/vpc/aws"

  # vpc setting
  name                    = var.resource_name.vpc_name
  cidr                    = var.vpc_config.vpc_cidr
  enable_dns_hostnames    = var.vpc_config.enable_dns_hostnames
  enable_dns_support      = var.vpc_config.enable_dns_support
  map_public_ip_on_launch = var.vpc_config.map_public_ip_on_launch

  # subnet setting
  azs                   = var.azs_config
  public_subnets        = var.subnets_config.public_subnets_cidr
  public_subnet_names   = var.resource_name.public_subnet_names
  private_subnets       = var.subnets_config.private_subnets_cidr
  private_subnet_names  = var.resource_name.private_subnet_names
  database_subnets      = var.subnets_config.database_subnets_cidr
  database_subnet_names = var.resource_name.database_subnet_names
  # intra_subnets         = var.subnets_config.intra_subnets_cidr

  # nat gateway setting
  nat_gateway_tags       = var.resource_name.nat_gateway_name_tags
  enable_nat_gateway     = var.subnets_config.enable_nat_gateway
  single_nat_gateway     = var.subnets_config.single_nat_gateway
  one_nat_gateway_per_az = var.subnets_config.one_nat_gateway_per_az

  # database subnet setting
  create_database_subnet_group           = var.subnets_config.create_database_subnet_group
  create_database_subnet_route_table     = var.subnets_config.create_database_subnet_route_table
  create_database_nat_gateway_route      = var.subnets_config.create_database_nat_gateway_route
  create_database_internet_gateway_route = var.subnets_config.create_database_internet_gateway_route
}
