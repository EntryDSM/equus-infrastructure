locals {
  service_names   = var.service_names
}

module "ecs" {
  source = "./modules/ecs"
  service_name   = local.service_names
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
  path_list = var.path_list
  acm_arn = module.route53.acm_arn
}