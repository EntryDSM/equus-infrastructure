variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "tag_name" {
  type    = string
  default = "service"
}
variable "container_port" {
  type    = number
  default = 8888
}

variable "service_name" {
  type = list(string)
  default = ["user-stag", "feed-stag"]
}

variable "host_port" {
  type    = number
  default = 80
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "namespace_id" {
  default = "equus.com"
}