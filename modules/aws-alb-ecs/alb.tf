# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 6.0"

#   name = "${var.application_name}-alb"

#   load_balancer_type = "application"
#   vpc_id             = module.vpc.vpc_id
#   subnets            = module.vpc.public_subnets
#   security_groups    = [module.alb_security_group.security_group_id]
#   ip_address_type    = "ipv4"

#   target_groups = [
#     {
#       name             = "${var.application_name}-tg"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#     }
#   ]

#   http_tcp_listeners = [
#     {
#       port               = 80
#       protocol           = "HTTP"
#       target_group_index = 0
#     }
#   ]
# }

resource "aws_lb" "main" {
  name                       = "${var.application_name}-alb-${var.environment}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = aws_security_group.alb.*.id
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "main" {
  name        = "${var.application_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  count             = length(var.public_subnets)
  load_balancer_arn = element(aws_lb.main.*.id, count.index)
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:ap-southeast-2:569265449628:certificate/e6bf74d9-68fd-49b5-a937-454ea5c70710"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}
