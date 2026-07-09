resource "aws_lb" "main" {
  name               = "${var.lb_name}-lb"
  internal           = var.lb_name == "frontend" ? false : true
  load_balancer_type = "application"
  security_groups    = [local.lb_sg_ids]
  subnets            = local.subnet_ids

  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-${var.lb_name}-lb"
    }
  )
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Welcome! This page is created by terraform</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.lb_name == "backend" ? "*.backend-lb-${var.environment}.${local.domain_name}" : "${var.project}-${var.environment}.${local.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true
}