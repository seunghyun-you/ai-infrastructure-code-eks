variable "convention" {
  description = "Naming convention for the environment"
  type        = string
  default     = "sample-env"
}

variable "region_information" {
  description = "Naming convention for the environment"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    vpc_cidr                = string
    enable_dns_hostnames    = bool
    enable_dns_support      = bool
    map_public_ip_on_launch = bool
  })
  default = {
    vpc_cidr                = "10.0.0.0/16"
    enable_dns_hostnames    = true
    enable_dns_support      = true
    map_public_ip_on_launch = true
  }
}

variable "subnets_config" {
  description = "Subnet configuration"
  type = object({
    # subnet cidr
    public_subnets_cidr = list(string)
    # intra_subnets_cidr    = list(string)
    private_subnets_cidr  = list(string)
    database_subnets_cidr = list(string)
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
  default = {
    # subnet cidr
    public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
    # intra_subnets_cidr    = ["10.0.40.224/28", "10.0.40.240/28"] # eks dataplane
    private_subnets_cidr  = ["10.0.41.0/24", "10.0.42.0/24"]
    database_subnets_cidr = ["10.0.81.0/24", "10.0.82.0/24"]
    # gateway setting
    enable_nat_gateway     = true
    single_nat_gateway     = true
    one_nat_gateway_per_az = false
    # db subnet setting for rds aurora
    create_database_subnet_group           = true
    create_database_subnet_route_table     = true
    create_database_nat_gateway_route      = false
    create_database_internet_gateway_route = false
  }
}

variable "ec2_types" {
  description = "each ec2 instance type setting"
  type = object({
    bastion_type  = string
    eks_workspace = string
  })
  default = {
    bastion_type  = "t3.micro"
    eks_workspace = "t3.micro"
  }
}

variable "eks_config" {
  description = "eks cluster setting"
  type = object(
    {
      cluster_version                          = string
      cluster_endpoint_private_access          = optional(bool)
      cluster_endpoint_public_access           = optional(bool)
      enable_cluster_creator_admin_permissions = optional(bool)
      eks_node_type                            = optional(string)
      cluster_addons = optional(map(
        object({})
      ))
      fargate_profiles = map(
        object(
          {
            name = string
            selectors = list(object(
              {
                namespace = string
              }
            ))
          }
        )
      )
      eks_cloudwatch_logging_items = list(string)
    }
  )
  default = {
    cluster_version                          = "1.31"
    cluster_endpoint_private_access          = true
    cluster_endpoint_public_access           = true
    enable_cluster_creator_admin_permissions = true

    eks_node_type = null

    cluster_addons = {
      coredns = {
        configuration_values = {
          computeType  = "fargate"
          replicaCount = 1
        }
        resolve_conflicts = "OVERWRITE"
      }
      vpc-cni    = { resolve_conflicts = "OVERWRITE" }
      kube-proxy = {}
    }

    fargate_profiles = {
      default = {
        name = "fargate-profile-default"
        selectors = [
          { namespace = "default" },
          { namespace = "kube-system" }
        ]
      }
      argocd = {
        name = "fargate-profile-argocd"
        selectors = [
          { namespace = "argocd" }
        ]
      }
      llm = {
        name = "fargate-profile-llm"
        selectors = [
          { namespace = "llm" }
        ]
      }
    }

    eks_cloudwatch_logging_items = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  }
}
