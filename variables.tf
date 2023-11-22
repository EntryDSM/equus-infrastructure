variable "rds_master_password" {
  type = string
}

variable "path_list" {
  default = {
    "user" : ["/user/**","/admin/**","/user","/admin"],
    "feed" : ["/faq/**", "/question/**","/faq/**","/faq","/question","/faq"],
    "banner" : ["/banner/**","/banner"],
    "application" : ["/application/**"],
    "status" : ["/status/**"]
  }
}

variable "service_names" {
  default = ["user-stag", "feed-stag","banner-stag","application-stag","status-stag"]
}

variable "dd_api_key" {
  type = string
}