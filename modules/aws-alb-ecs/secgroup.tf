# module "alb_security_group" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = ">3.2.0"

#   name   = "${var.application_name}-alb-sg"
#   vpc_id = module.vpc.vpc_id

#   # Ingress for HTTP
#   ingress_cidr_blocks      = ["0.0.0.0/0"]
#   ingress_ipv6_cidr_blocks = ["::/0"]
#   ingress_rules            = ["http-80-tcp"]

#   # Allow all egress
#   egress_cidr_blocks      = ["0.0.0.0/0"]
#   egress_ipv6_cidr_blocks = ["::/0"]
#   egress_rules            = ["all-all"]
# }
resource "aws_security_group" "alb" {
  name   = "${var.application_name}-sg-alb-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.application_name}-sg-task-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = var.container_port
    to_port          = var.container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
