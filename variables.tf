variable "rds_master_password" {
  type = string
}

variable "path_list" {
  default = {
    "user" : ["/user/**", "/admin/**"],
    "feed" : ["/faq/**", "/question/**"],
    "banner" : ["/banner/**"],
    "application" : ["/application/**",  "/graduation/**", "/score/**"],
    "schedule" : ["/schedule/**"]
  }
}

variable "service_names" {
  default = ["user-stag", "feed-stag", "banner-stag", "application-stag", "schedule-stag"]
}

variable "dd_api_key" {
  type = string
}

variable "aws_account_id" {}

variable "access_key_id" {}

variable "secret_key_id" {}