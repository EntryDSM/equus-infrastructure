resource "aws_lb" "equus_lb" {
  name               = "equus-lb"
  subnets            = var.subnet_ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.equus_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.equus_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "equus_listener_rule" {
  listener_arn = aws_lb_listener.https_forward.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.equus_tg.arn
  }
  condition {
    path_pattern {
      values = ["/**"]
    }
  }
}

resource "aws_lb_target_group" "equus_tg" {
  name        = "api-gateway-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}