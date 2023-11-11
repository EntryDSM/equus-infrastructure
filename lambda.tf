locals {
  function_name = "equus-auth-function"
  handler       = "AuthHandler::handleRequest"
  runtime       = "java17"
  source_path   = "/Users/buhyeonsu/Desktop/Entry-Dsm/Infrastructure/equus-infrastructure/Equus-Lambda-Auth.jar"
  s3_bucket     = module.lambda_storage.bucket
}

module "auth_lambda" {
  source = "./modules/lambda"

  function_name  = local.function_name
  handler        = local.handler
  runtime        = local.runtime
  source_path    = local.source_path
  s3_bucket      = local.s3_bucket
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}