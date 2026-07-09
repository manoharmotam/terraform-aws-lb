locals {
  common_name = "${var.project}-${var.environment}"
  common_tags = {
    Project      = "${var.project}"
    Environment  = "${var.environment}"
    Name         = "${local.common_name}"
    "Managed by" = "Terraform"
  }
  private_subnet_ids       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  public_subnet_ids        = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  subnet_ids = var.lb_name == "frontend" ? local.public_subnet_ids : local.private_subnet_ids 
  lb_sg_ids = var.lb_name == "frontend" ? local.frontend_lb_sg_id : local.backend_lb_sg_id
  backend_lb_sg_id = data.aws_ssm_parameter.backend_lb_sg.value
  # backend_lb_arn   = aws_lb.main.arn
  domain_name      = "${var.project}.online"
  certificate_arn   = data.aws_ssm_parameter.certificate_arn.value
  frontend_lb_sg_id = data.aws_ssm_parameter.frontend_lb_sg.value
  # frontend_lb_arn   = aws_lb.main.arn
  # lb_arn = var.lb_name == "frontend" ? local.frontend_lb_arn : local.backend_lb_arn
}