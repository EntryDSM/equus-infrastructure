locals {
  name_prefix = "equus"
  ecr_names = [
    "user-stag",
    "feed-stag"
  ]
  region = "ap-northeast-2"
}

locals {
  stag_ecr_names = toset([
    for name in local.ecr_names : name if endswith(name, "-stag")
  ])
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5

  prod_ecr_names = toset([
    for name in local.ecr_names : name if endswith(name, "-prod")
  ])
  prod_tag_prefix = "prod-"
  prod_tag_limit  = 5
}

module "stag_ecr" {
  source = "./modules/ecr"

  for_each = local.stag_ecr_names
  name = each.value

  image_limit = local.stag_tag_limit
  tag_prefix  = local.stag_tag_prefix
}

module "prod_ecr" {
  source = "./modules/ecr"

  for_each = local.prod_ecr_names
  name     = each.value

  image_limit = local.prod_tag_limit
  tag_prefix  = local.prod_tag_prefix
}

output "stag_ecr_url" {
  value = [
    for v in module.stag_ecr : v.ecr_repository_url
  ]
}

output "prod_ecr_url" {
  value = [
    for v in module.prod_ecr : v.ecr_repository_url
  ]
}
