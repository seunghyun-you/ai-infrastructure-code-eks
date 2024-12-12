variable "key_pair_config" {
  description = "pem key setting"
  type = object({
    key_name           = string
    create_private_key = bool
    filename           = string
    file_permission    = string
  })
}

variable "ec2_config" {
  description = "ec2 setting"
  type = map(
    object(
      {
        ami                    = string
        key_name               = string
        subnet_id              = string
        instance_type          = string
        vpc_security_group_ids = list(string)
        iam_instance_profile   = optional(string)
        ec2_name               = map(string)
      }
    )
  )
}
