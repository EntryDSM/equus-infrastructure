variable "rds_master_password" {
  type = string
}

variable "service_names" {
  default = ["user", "feed", "banner", "application", "schedule", "equus-api-gateway", "status"]
}

variable "dd_api_key" {
  type = string
}

variable "aws_account_id" {}

variable "access_key_id" {}

variable "secret_key_id" {}