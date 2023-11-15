locals {
  domain = "entry-equus.site"
  dns_name = module.ecs.lb_dns_name
  zone_id = module.ecs.lb_zone_id
}

module "route53" {
  source = "./modules/domain"

  domain = local.domain
  lb_dns_name = local.dns_name
  lb_zone_id = local.zone_id
}