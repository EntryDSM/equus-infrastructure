variable "rds_master_password" {
  type = string
}

variable "service_names" {
  default = ["user-stag", "feed-stag", "banner-stag", "application-stag", "schedule-stag", "equus-api-gateway-stag", "status-stag"]
}

variable "dd_api_key" {
  type = string
}

variable "aws_account_id" {}

variable "access_key_id" {}

variable "secret_key_id" {}