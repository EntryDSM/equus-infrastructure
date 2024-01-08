locals {
  equus_bucket_name = "equus-bucket"
}

module "lambda_storage" {
  source = "./modules/s3"

  bucket_name = local.equus_bucket_name
}