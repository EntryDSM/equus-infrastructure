locals {
  service_names   = var.service_names
  dd_api_key = var.dd_api_key
}

module "ecs" {
  source = "./modules/ecs"
  service_name   = local.service_names
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
  path_list = var.path_list
  acm_arn = module.route53.acm_arn
  DD_API_KEY = local.dd_api_key
  aws_account_id = var.aws_account_id
  access_key_id = var.access_key_id
  secret_key_id = var.secret_key_id
}