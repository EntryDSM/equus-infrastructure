variable "function_name" {
  type = string
}

variable "description" {
  type = string
  default = "Lambda Function"
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "source_path" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}