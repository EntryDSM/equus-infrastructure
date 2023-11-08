locals {
  repository_url = module.stag_ecr.ecr_repository_url
  service_name = "user-stag"
}

module "ecs" {
  source = "./modules/ecs"

  repository_url = local.repository_url
  service_name   = local.service_name
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}