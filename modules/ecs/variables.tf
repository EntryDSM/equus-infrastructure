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
  default = 8080
}

variable "service_name" {
  type = string
}

variable "host_port" {
  type    = number
  default = 80
}

variable "repository_url" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}