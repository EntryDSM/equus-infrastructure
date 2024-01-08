locals {
  jenkins_ami = "ami-0b87469597f2d8862"
  kafka_ami = "ami-0cfabecf3a486037e"
  equus_vpc = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  domain_zone_id = module.route53.domain_zone_id
}

module "jenkins" {
  source = "./modules/ec2"
  ami = local.jenkins_ami
  vpc_id = local.equus_vpc
  subnet_id = local.public_subnet_id
  instance_type = "t2.micro"
  ec2_name = "equus-jenkins-server"
  record_name = "jenkins"
  zone_id = local.domain_zone_id

  user_data = <<-EOF
      #!/bin/sh
      systemctl start docker
      systemctl start jenkins
EOF
}

module "kafka" {
  source = "./modules/ec2"
  ami = local.kafka_ami
  vpc_id = local.equus_vpc
  subnet_id = local.public_subnet_id
  instance_type = "t3a.medium"
  ec2_name = "equus-kafka-cluster"
  ingress_rule = ["9092"]
  record_name = "kafka"
  zone_id = local.domain_zone_id
  user_data = <<-EOF
      #!/bin/sh
      su ec2-user
      cd /home/ec2-user/
      sudo kafka_2.12-2.5.0/bin/zookeeper-server-start.sh -daemon kafka_2.12-2.5.0/config/zookeeper.properties
      sudo kafka_2.12-2.5.0/bin/kafka-server-start.sh -daemon kafka_2.12-2.5.0/config/server.properties
EOF
}