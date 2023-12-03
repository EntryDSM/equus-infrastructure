#locals {
#  bucket_names = toset(["banner-stag"])
#
#}
#
#module "lambda_storage" {
#  for_each = local.bucket_names
#  source = "./modules/s3"
#
#  bucket_name = each.value
#}