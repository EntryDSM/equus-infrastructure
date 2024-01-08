variable "rds_master_password" {
  type = string
}

variable "path_list" {
  default = {
    "user" : ["/user/**","/admin/**","/user","/admin"],
    "feed" : ["/faq/**", "/question/**","/faq/**","/faq","/question","/faq"],
    "banner" : ["/banner/**","/banner"],
    "application" : ["/application/**","/application"]
  }
}

variable "service_names" {
  default = ["user-stag", "feed-stag","banner-stag","application-stag"]
}

variable "dd_api_key" {
  type = string
}

variable "aws_account_id" {}

variable "access_key_id" {}

variable "secret_key_id" {}