resource "aws_ssm_parameter" "backend_lb_listener_arn" {
  name      = var.lb_name == "backend" ? "/${var.project}/${var.environment}/backend_alb_listener_arn" : "/${var.project}/${var.environment}/frontend_alb_listener_arn"
  type      = "String"
  value     = aws_lb_listener.main.arn
  overwrite = true
}
