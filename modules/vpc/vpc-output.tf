output "vpc_info" {
  description = "VPC information"
  value = {
    vpc_id                  = module.ap_northeast_2.vpc_id
    vpc_cidr_block          = module.ap_northeast_2.vpc_cidr_block
    private_subnets         = module.ap_northeast_2.private_subnets
    public_subnets          = module.ap_northeast_2.public_subnets
    database_subnets        = module.ap_northeast_2.database_subnets
    nat_public_ips          = module.ap_northeast_2.nat_public_ips
    private_route_table_ids = module.ap_northeast_2.private_route_table_ids
    public_route_table_ids  = module.ap_northeast_2.public_route_table_ids
    # intra_subnets_ids       = module.ap_northeast_2.intra_subnets
  }
}
