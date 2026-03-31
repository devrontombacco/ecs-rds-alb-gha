# Target Group

resource "aws_lb_target_group" "tg" {
  name        = "${var.vpc_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-vpc.id
  target_type = "ip"
}

#  ALB 

resource "aws_lb" "alb" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  enable_deletion_protection = false

  # I will uncomment this in the future if I decide to add S3 bucket for logs
  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Name = "${var.vpc_name}-alb"
  }
}

# ALB Listener

resource "aws_lb_listener" "alb-listener-http" {
  load_balancer_arn = aws_lb.alb.arn
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

resource "aws_lb_listener" "alb-listener-https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
