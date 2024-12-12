locals {
  # personal information setting
  account_id = data.aws_caller_identity.aws_account_info.account_id
  my_ip      = "${chomp(data.http.myip.response_body)}/32"

  # resource naming
  network_resource_name = {
    vpc_name            = "${var.convention}-vpc-${substr(var.region_information, 0, 2)}"
    public_subnet_names = ["${var.convention}-sub-pub-01", "${var.convention}-sub-pub-02"]
    # intra_subnet_names    = ["${var.convention}-sub-eks-01", "${var.convention}-sub-eks-02"] # eks dataplane
    private_subnet_names  = ["${var.convention}-sub-pri-01", "${var.convention}-sub-pri-02"]
    database_subnet_names = ["${var.convention}-sub-db-01", "${var.convention}-sub-db-02"]
    nat_gateway_name_tags = { "Name" : "${var.convention}-natgw" }
  }

  # resource config setting
  # availability zones information for subnet
  availability_zones = ["${var.region_information}a", "${var.region_information}c"]

  # vpc endpoint setting 
  vpc_endpoint_configs = {
    region             = var.region_information
    vpc_id             = module.vpc_ap.vpc_info.vpc_id
    service_type_check = ["s3", "dynamodb"]
    endpoints = {
      s3 = {
        service             = "s3"
        subnet_ids          = null
        security_group_ids  = null
        private_dns_enabled = null
        tags                = { Name = "${var.convention}-vpc-endpoint-s3" }
      },
      sts = {
        service             = "sts"
        subnet_ids          = module.vpc_ap.vpc_info.private_subnets
        security_group_ids  = [module.security_group_ap.sg_ids.endpoint_sg_id]
        private_dns_enabled = true
        tags                = { Name = "${var.convention}-vpc-endpoint-sts" }
      },
      ec2 = {
        service             = "ec2"
        subnet_ids          = module.vpc_ap.vpc_info.private_subnets
        security_group_ids  = [module.security_group_ap.sg_ids.endpoint_sg_id]
        private_dns_enabled = true
        tags                = { Name = "${var.convention}-vpc-endpoint-ec2" }
      },
      ecr-api = {
        service             = "ecr.api"
        subnet_ids          = module.vpc_ap.vpc_info.private_subnets
        security_group_ids  = [module.security_group_ap.sg_ids.endpoint_sg_id]
        private_dns_enabled = true
        tags                = { Name = "${var.convention}-vpc-endpoint-ecr.api" }
      },
      ecr-dkr = {
        service             = "ecr.dkr"
        subnet_ids          = module.vpc_ap.vpc_info.private_subnets
        security_group_ids  = [module.security_group_ap.sg_ids.endpoint_sg_id]
        private_dns_enabled = true
        tags                = { Name = "${var.convention}-vpc-endpoint-ecr.dkr" }
      },
      eks = {
        service             = "eks"
        subnet_ids          = module.vpc_ap.vpc_info.private_subnets
        security_group_ids  = [module.security_group_ap.sg_ids.endpoint_sg_id]
        private_dns_enabled = true
        tags                = { Name = "${var.convention}-vpc-endpoint-eks" }
      }
    }
  }

  # security group setting
  security_group_config = {
    endpoint = {
      sg_name     = "${var.convention}-sg-endpoints"
      vpc_id      = module.vpc_ap.vpc_info.vpc_id
      description = "Allow 443, 53 port traffic for VPC internal resources"
      ingress_rule = [
        {
          from_port   = "443"
          to_port     = "443"
          protocol    = "tcp"
          cidr_blocks = module.vpc_ap.vpc_info.vpc_cidr_block
        },
        {
          from_port   = "53"
          to_port     = "53"
          protocol    = "udp"
          cidr_blocks = module.vpc_ap.vpc_info.vpc_cidr_block
        }
      ]
      egress_rule        = null
      common_egress_rule = ["all-all"]
    }
    ec2_bastion = {
      sg_name     = "${var.convention}-sg-ec2-bastion"
      vpc_id      = module.vpc_ap.vpc_info.vpc_id
      description = "Allow 22 port traffic for my ip to access bastion server"
      ingress_rule = [
        {
          from_port   = "22"
          to_port     = "22"
          protocol    = "tcp"
          cidr_blocks = local.my_ip
        }
      ]
      egress_rule        = null
      common_egress_rule = ["all-all"]
    }
    ec2_eks_workspace = {
      sg_name     = "${var.convention}-sg-ec2-eks-workspace"
      vpc_id      = module.vpc_ap.vpc_info.vpc_id
      description = "Allow all internal VPC traffic"
      ingress_rule = [
        {
          from_port   = "0"
          to_port     = "0"
          protocol    = "-1"
          cidr_blocks = var.vpc_config.vpc_cidr
        }
      ]
      egress_rule        = null
      common_egress_rule = ["all-all"]
    }
    ec2_eks_cluster = {
      sg_name     = "${var.convention}-sg-ec2-eks-cluster"
      vpc_id      = module.vpc_ap.vpc_info.vpc_id
      description = "Allow all internal VPC traffic"
      ingress_rule = [
        {
          from_port   = "0"
          to_port     = "0"
          protocol    = "-1"
          cidr_blocks = var.vpc_config.vpc_cidr
        }
      ]
      egress_rule        = null
      common_egress_rule = ["all-all"]
    }
  }

  # ec2 pem key setting
  key_pair_config = {
    key_name           = "${var.convention}-pem-ec2-ap"
    create_private_key = "true"
    filename           = "./access_info/${var.convention}-pem-ec2-ap.pem"
    file_permission    = "0600"
  }

  # ec2 setting
  ec2_config = {
    bastion = {
      ami                    = data.aws_ami.amazon_linux_2023.id
      key_name               = local.key_pair_config.key_name
      subnet_id              = module.vpc_ap.vpc_info.public_subnets[0]
      instance_type          = var.ec2_types.bastion_type
      vpc_security_group_ids = [module.security_group_ap.sg_ids.ec2_bastion_sg_id]
      iam_instance_profile   = module.iam.iam_role_ids.ec2_bastion_role_id
      ec2_name               = { Name = "${var.convention}-ec2-bastion" }
    }
    eks_workspace = {
      ami                    = data.aws_ami.amazon_linux_2023.id
      key_name               = local.key_pair_config.key_name
      subnet_id              = module.vpc_ap.vpc_info.private_subnets[0]
      instance_type          = var.ec2_types.eks_workspace
      vpc_security_group_ids = [module.security_group_ap.sg_ids.ec2_eks_workspace_sg_id]
      iam_instance_profile   = module.iam.iam_role_ids.ec2_eks_workspace_role_id
      ec2_name               = { Name = "${var.convention}-ec2-eks-workspace" }
    }
  }

  # eks setting
  eks_config = {
    vpc_id                          = module.vpc_ap.vpc_info.vpc_id
    subnet_ids                      = module.vpc_ap.vpc_info.private_subnets
    cluster_endpoint_private_access = var.eks_config.cluster_endpoint_private_access
    cluster_endpoint_public_access  = var.eks_config.cluster_endpoint_public_access

    cluster_name                             = "${var.convention}-eks-cluster"
    cluster_version                          = var.eks_config.cluster_version
    cluster_addons                           = var.eks_config.cluster_addons
    cluster_additional_security_group_ids    = [module.security_group_ap.sg_ids.ec2_eks_cluster_sg_id]
    enable_cluster_creator_admin_permissions = var.eks_config.enable_cluster_creator_admin_permissions

    enable_irsa = true
    access_entries = {
      eks_workspace_adm = {
        kubernetes_groups = []
        principal_arn     = module.iam.iam_role_ids.ec2_eks_workspace_role_arn

        policy_associations = {
          admin = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
      infra_adm = {
        # kubernetes_groups = ["system:masters"]
        principal_arn = "arn:aws:sts::602229900482:role/ec2-role-ssmcore"

        policy_associations = {
          admin = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
    }

    fargate_profiles = var.eks_config.fargate_profiles

    eks_cloudwatch_logging_items = var.eks_config.eks_cloudwatch_logging_items
  }

  # iam setting
  iam_config = {
    bastion_role = {
      role_name = "${var.convention}-role-ec2-ssm-core"

      create_role             = true
      create_instance_profile = true
      role_requires_mfa       = false

      # NOTE :: Session Tag Sample
      # aws sts assume-role --role-arn arn:aws:iam::123456789012:role/MyRole --role-session-name MySession --tags Key=Project,Value=Gemini Key=Department,Value=Engineering
      trusted_role_actions  = ["sts:AssumeRole", "sts:TagSession"]
      trusted_role_services = ["ec2.amazonaws.com"]

      attach_admin_policy     = false
      attach_poweruser_policy = false
      custom_role_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
    eks_workspace_role = {
      role_name = "${var.convention}-role-ec2-eks-workspace"

      create_role             = true
      create_instance_profile = true
      role_requires_mfa       = false

      # NOTE :: Session Tag Sample
      trusted_role_actions  = ["sts:AssumeRole", "sts:TagSession"]
      trusted_role_services = ["ec2.amazonaws.com"]

      attach_admin_policy     = false
      attach_poweruser_policy = false
      custom_role_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
        "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      ]
    }
  }
}
