variable "vpc_endpoint_configs" {
  type = object({
    region             = string
    vpc_id             = string
    service_type_check = list(string)
    endpoints = map(object({
      service             = string
      subnet_ids          = list(string)
      security_group_ids  = list(string)
      private_dns_enabled = bool
      tags                = map(string)
    }))
  })
}

