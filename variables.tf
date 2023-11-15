variable "rds_master_password" {
  type = string
}

variable "path_list" {
  default = {
    "user" : ["/user/**","/admin/**"],
    "feed" : ["/faq/**", "/question/**","/faq/**"]
  }
}

variable "service_names" {
  default = ["user-stag", "feed-stag"]
}