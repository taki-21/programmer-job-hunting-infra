resource "aws_security_group" "security_group" {
  name = "${var.app_name}-alb"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.app_name}-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "programmer-job-hunting-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.security_group.id]
  subnets         = var.public_subnet_ids
}

resource "aws_lb_listener" "http" {
  # HTTPでのアクセスを受け付ける
  port     = "80"
  protocol = "HTTP"
  load_balancer_arn = aws_lb.alb.arn
  # "ok" という固定レスポンスを設定する
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}
resource "aws_lb_listener" "https" {
  port     = "443"
  protocol = "HTTPS"
  load_balancer_arn = aws_lb.alb.arn
  certificate_arn   = var.acm_id
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

resource "aws_route53_record" "this" {
  type    = "A"
  name    = var.domain
  zone_id = data.aws_route53_zone.this.id
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
