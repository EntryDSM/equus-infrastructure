locals {
  service_names   = toset(["user-stag", "feed-stag"])
}

module "ecs" {
  source = "./modules/ecs"
  service_name   = local.service_names
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
}