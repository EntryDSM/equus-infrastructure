module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  public_subnets  = var.public_subnets

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_support = true
  enable_dns_hostnames = true

  map_public_ip_on_launch = true
}
