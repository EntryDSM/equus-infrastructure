locals {
  jenkins_ami = "ami-0686bea6461700cfe"
  equus_vpc = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

module "ec2" {
  source = "./modules/ec2"
  ami = local.jenkins_ami
  vpc_id = local.equus_vpc
  subnet_id = local.public_subnet_id
  instance_type = "t2.micro"
  ec2_name = "equus-jenkins-server"
}