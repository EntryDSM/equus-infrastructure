resource "aws_lb" "equus_lb" {
  name               = "equus-lb"
  subnets            = var.subnet_ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Application = var.service_name
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.equus_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.equus_tg.arn
  }
}

resource "aws_lb_target_group" "equus_tg" {
  name        = "${var.service_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}