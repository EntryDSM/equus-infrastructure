#resource "aws_instance" "jenkins" {
#  ami = "ami-0e865819ed78121c7"
#  instance_type = "t2.micro"
#  associate_public_ip_address = true
#  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
#}
#
#resource "aws_security_group" "jenkins_sg" {
#  name_prefix = "cicd-sg"
#  vpc_id = module.vpc.vpc_id
#}
#
#resource "aws_security_group_rule" "jenkins_sg_ingress_ssh" {
#  type        = "ingress"
#  from_port   = 22
#  to_port     = 22
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.jenkins_sg.id
#}
#
#resource "aws_security_group_rule" "jenkins_sg_egress_all" {
#  type             = "egress"
#  from_port        = 0
#  to_port          = 0
#  protocol         = "-1"
#  cidr_blocks      = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.jenkins_sg.id
#}