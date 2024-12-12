variable "resource_name" {
  description = "VPC configuration for different regions"
  type = object({
    vpc_name              = string
    public_subnet_names   = list(string)
    private_subnet_names  = list(string)
    database_subnet_names = list(string)
    nat_gateway_name_tags = map(string)
  })
}

variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    vpc_cidr                = string
    enable_dns_hostnames    = bool
    enable_dns_support      = bool
    map_public_ip_on_launch = bool
  })
}

variable "azs_config" {
  description = "availability zones configuration"
  type        = list(string)
}

variable "subnets_config" {
  description = "Subnet configuration"
  type = object({
    # subnet cidr
    public_subnets_cidr   = list(string)
    private_subnets_cidr  = list(string)
    database_subnets_cidr = list(string)
    # intra_subnets_cidr    = list(string)
    # gateway setting
    enable_nat_gateway     = bool
    single_nat_gateway     = bool
    one_nat_gateway_per_az = bool
    # db subnet setting for rds aurora
    create_database_subnet_group           = bool
    create_database_subnet_route_table     = bool
    create_database_nat_gateway_route      = bool
    create_database_internet_gateway_route = bool
  })
}
