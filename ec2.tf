locals {
  jenkins_ami = "ami-0686bea6461700cfe"
  kafka_ami = "ami-06ed78ce9f402f17f"
  equus_vpc = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

module "jenkins" {
  source = "./modules/ec2"
  ami = local.kafka_ami
  vpc_id = local.equus_vpc
  subnet_id = local.public_subnet_id
  instance_type = "t2.micro"
  ec2_name = "equus-jenkins-server"
}
module "kafka" {
  source = "./modules/ec2"
  ami = local.kafka_ami
  vpc_id = local.equus_vpc
  subnet_id = local.public_subnet_id
  instance_type = "t2.medium"
  ec2_name = "equus-kafka-cluster"
  ingress_rule = ["9092"]
}