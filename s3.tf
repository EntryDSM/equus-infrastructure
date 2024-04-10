locals {
  equus_bucket_name = "dsm-s3-bucket-entry"
}

module "entry_storage" {
  source = "./modules/s3"

  bucket_name = local.equus_bucket_name
}