locals {
  lambda_storage_name = "equus-lambda-bucket"
}

module "lambda_storage" {
  source = "./modules/s3"

  bucket_name = local.lambda_storage_name
}