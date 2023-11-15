variable "rds_master_password" {
  type = string
}

variable "path_list" {
  default = {
    "user" : ["/user/**","/admin/**"],
    "feed" : ["/faq/**", "/question/**","/faq/**"]
  }
}