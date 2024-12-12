variable "security_group_config" {
  description = "security group setting"
  type = map(
    object(
      {
        sg_name     = string
        vpc_id      = string
        description = string
        ingress_rule = list(
          object(
            {
              from_port   = number
              to_port     = number
              protocol    = string
              cidr_blocks = string
            }
          )
        )
        egress_rule = optional(list(
          object(
            {
              from_port   = number
              to_port     = number
              protocol    = string
              cidr_blocks = string
            }
          )
        ))
        common_egress_rule = optional(list(string))
      }
    )
  )
}
