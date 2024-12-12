module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Network setting
  vpc_id                          = var.eks_config.vpc_id
  subnet_ids                      = var.eks_config.subnet_ids
  cluster_endpoint_private_access = var.eks_config.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.eks_config.cluster_endpoint_public_access

  # Cluster setting
  cluster_name                          = var.eks_config.cluster_name
  cluster_version                       = var.eks_config.cluster_version
  cluster_addons                        = var.eks_config.cluster_addons
  cluster_additional_security_group_ids = var.eks_config.cluster_additional_security_group_ids
  # enable_cluster_creator_admin_permissions = var.eks_config.enable_cluster_creator_admin_permissions
  enable_cluster_creator_admin_permissions = true

  # IAM Role & Service Account setting
  enable_irsa    = var.eks_config.enable_irsa
  access_entries = var.eks_config.access_entries

  # Fargate prifiles setting
  fargate_profiles = var.eks_config.fargate_profiles

  # CloudWatch logging setting
  cluster_enabled_log_types = var.eks_config.eks_cloudwatch_logging_items
}

module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "aws-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# data "http" "iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.0/docs/install/iam_policy.json"
# }

# resource "aws_iam_role_policy" "controller" {
#   name_prefix = "AWSLoadBalancerControllerIAMPolicy"
#   policy      = data.http.iam_policy.body
#   role        = module.load_balancer_controller_irsa_role.iam_role_name
# }

# resource "helm_release" "release" {
#   name       = "aws-load-balancer-controller"
#   chart      = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_id
#   }
#   set {
#     name  = "serviceAccount.create"
#     value = false
#   }
#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#   set {
#     name  = "region"
#     value = "ap-northeast-2"
#   }
#   set {
#     name  = "vpcId"
#     value = var.eks_config.vpc_id
#   }
#   # set {
#   #   name  = "image.repository"
#   #   value = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
#   # }
#   # set {
#   #   name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#   #   value = module.load_balancer_controller_irsa_role.iam_role_arn
#   # }
# }

# resource "kubernetes_service_account" "aws_lb_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     # annotations = {
#     #   "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
#     # }
#   }
# }
# resource "kubernetes_service_account" "alb_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"

#     annotations = {
#       "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
#     }
#   }
# }
