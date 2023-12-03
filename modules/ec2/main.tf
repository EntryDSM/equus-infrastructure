resource "aws_instance" "equus" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.equus_ec2_sg.id]

  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "equus_ec2_sg" {
  name_prefix = "cicd-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "equus_ec2_sg_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.equus_ec2_sg.id
}

resource "aws_security_group_rule" "equus_ec2_sg_ingress_8080" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.equus_ec2_sg.id
}

resource "aws_security_group_rule" "equus_ec2_sg_egress_all" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.equus_ec2_sg.id
}

output "ec2_public_ip" {
  value = aws_instance.equus.public_ip
}