resource "aws_security_group" "lb" {
  vpc_id = var.vpc_id
  name   = "lb-sg"
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb_sg"
  }
}

resource "aws_security_group" "ecs_task" {
  vpc_id = var.vpc_id
  name = "ecs-task-sg"

  ingress {
    from_port = var.host_port
    protocol  = "tcp"
    to_port   = var.container_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_task_sg"
  }
}