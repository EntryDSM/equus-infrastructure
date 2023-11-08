variable "name" {
  type        = string
  description = "ecr repository name"
}

variable "image_limit" {
  type        = number
  description = "image limit"
}

variable "tag_prefix" {
  type        = string
  description = "tag prefix"
}