variable "eks_config" {
  description = "eks setting"
  type = object(
    {
      vpc_id                                   = string
      subnet_ids                               = list(string)
      cluster_endpoint_private_access          = optional(bool)
      cluster_endpoint_public_access           = optional(bool)
      enable_cluster_creator_admin_permissions = optional(bool)

      cluster_name                          = string
      cluster_version                       = string
      cluster_addons                        = any
      cluster_additional_security_group_ids = list(string)

      enable_irsa    = bool
      access_entries = any

      fargate_profiles             = any
      eks_cloudwatch_logging_items = list(string)
    }
  )
}
