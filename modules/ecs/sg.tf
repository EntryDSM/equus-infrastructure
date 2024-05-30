resource "aws_security_group" "lb" {
  vpc_id = var.vpc_id
  name   = "lb-sg-${var.environment}"
  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
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

resource "aws_security_group_rule" "sg_rule" {
  count = length(var.service_name)
  from_port         = 8080 + count.index
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  to_port           = 8080 + count.index
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "ecs_task" {
  vpc_id = var.vpc_id
  name = "ecs-task-sg-${var.environment}"

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self = true
  }

  ingress {
    from_port = var.host_port
    protocol  = "tcp"
    to_port   = var.container_port
    security_groups = [aws_security_group.lb.id]
  }
  ingress {
    from_port = 8126
    protocol  = "tcp"
    to_port   = 8126
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    from_port = 5001
    protocol  = "tcp"
    to_port   = 5001
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