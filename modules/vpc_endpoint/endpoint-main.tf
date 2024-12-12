resource "aws_vpc_endpoint" "this" {
  for_each = var.vpc_endpoint_configs.endpoints

  vpc_id              = var.vpc_endpoint_configs.vpc_id
  service_name        = "com.amazonaws.${var.vpc_endpoint_configs.region}.${each.value.service}"
  vpc_endpoint_type   = contains(var.vpc_endpoint_configs.service_type_check, each.key) ? "Gateway" : "Interface"
  subnet_ids          = each.value.subnet_ids
  security_group_ids  = each.value.security_group_ids
  private_dns_enabled = each.value.private_dns_enabled

  tags = each.value.tags
}
