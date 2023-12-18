variable "subnet_id" {}

variable "vpc_id" {}

variable "instance_type" {}

variable "ami" {}

variable "ec2_name" {}

variable "ingress_rule" {
  type = list(string)
  default = []
}