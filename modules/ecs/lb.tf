resource "aws_lb" "equus_lb" {
  name               = "equus-lb"
  subnets            = var.subnet_ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http_forward" {
  count = length(var.service_name)
  load_balancer_arn = aws_lb.equus_lb.arn
  port              = 8080 + count.index
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.equus_tg[count.index].arn
  }
}

resource "aws_lb_target_group" "equus_tg" {
  count = length(var.service_name)
  name        = "${var.service_name[count.index]}-tg"
  port        = 8080
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