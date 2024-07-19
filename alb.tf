resource "aws_lb_listener_rule" "rule" {
  listener_arn = var.lb_listener_arn
  priority     = var.lb_priority

  action {
    target_group_arn = aws_alb_target_group.tg.id
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/${var.service_path}/*"]
    }
  }

  dynamic "condition" {
    for_each = length(var.lb_host_headers) > 0 ? [1] : []
    content {
      host_header {
        values = var.lb_host_headers
      }
    }
  }
}

resource "aws_alb_target_group" "tg" {
  name     = "${local.project_env}-api"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path                = "/${var.service_path}/"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 5
    matcher = "200,202"
  }
}
