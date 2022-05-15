resource "aws_lb" "your_app_name" {
  name                       = "${var.alb_name}"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = "${var.enable_deletion_protection}"

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    # module.https_sg.security_group_id,
    # module.http_redirect_sg.security_group_id,
  ]
}

resource "aws_lb_target_group" "your_app_name" {
  name                 = "${var.alb_target_group_name}"
  target_type          = "ip"
  vpc_id               = aws_vpc.your_app_name.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.your_app_name]
}

resource "aws_lb_listener_rule" "your_app_name" {
  # listener_arn = aws_lb_listener.https.arn
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.your_app_name.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.your_app_name.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code  = "200"
    }
  }
}

# Security Groups
module "http_sg" {
  source      = "./security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.your_app_name.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

# module "https_sg" {
#   source      = "./security_group"
#   name        = "https-sg"
#   vpc_id      = aws_vpc.your_app_name.id
#   port        = 443
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "http_redirect_sg" {
#   source      = "./security_group"
#   name        = "http-redirect-sg"
#   vpc_id      = aws_vpc.your_app_name.id
#   port        = 8080
#   cidr_blocks = ["0.0.0.0/0"]
# }


# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.your_app_name.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.your_app_name.arn
#   ssl_policy        = "ELBSecurityPolicy-2016-08"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "これは『HTTPS』です"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_lb_listener" "redirect_http_to_https" {
#   load_balancer_arn = aws_lb.your_app_name.arn
#   port              = "8080"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }




# route53

# resource "aws_route53_record" "example_certificate" {
#   for_each = {
#     for dvo in aws_acm_certificate.your_app_name.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   name    = each.value.name
#   type    = each.value.type
#   records = [each.value.record]
#   zone_id = data.aws_route53_zone.your_app_name.id
#   ttl     = 60
# }

# resource "aws_route53_zone" "test_example" {
#   name = "test.your_app_name.com"
# }

# data "aws_route53_zone" "your_app_name" {
#   name = "example.com"
# }


# resource "aws_acm_certificate" "your_app_name" {
#   domain_name               = aws_route53_record.your_app_name.name
#   subject_alternative_names = []
#   validation_method         = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "your_app_name" {
#   zone_id = data.aws_route53_zone.your_app_name.zone_id
#   name    = data.aws_route53_zone.your_app_name.name
#   type    = "A"

#   alias {
#     name                   = aws_lb.your_app_name.dns_name
#     zone_id                = aws_lb.your_app_name.zone_id
#     evaluate_target_health = true
#   }
# }

# output "domain_name" {
#   value = aws_route53_record.your_app_name.name
# }

# resource "aws_acm_certificate_validation" "your_app_name" {
#   certificate_arn = aws_acm_certificate.your_app_name.arn
#   validation_record_fqdns = [
#     for record in aws_route53_record.your_app_name_certificate : record.fqdn
#   ]
# }

# output "alb_dns_name" {
#   value = aws_lb.your_app_name.dns_name
# }
