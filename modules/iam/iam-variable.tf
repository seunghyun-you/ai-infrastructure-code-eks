# NOTE :: (SPECIFICATION TABLE URL INFORMATION) 
# https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role
variable "iam_role_config" {
  description = "iam config"
  type = map(
    object(
      {
        role_name = string

        create_role             = optional(bool)
        create_instance_profile = optional(bool)
        role_requires_mfa       = optional(bool)

        trusted_role_actions  = optional(list(string))
        trusted_role_services = optional(list(string))

        attach_admin_policy     = optional(bool)
        attach_poweruser_policy = optional(bool)
        custom_role_policy_arns = optional(list(string))
      }
    )
  )
}
