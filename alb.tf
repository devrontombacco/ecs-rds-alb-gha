# Target Group

resource "aws_lb_target_group" "tg" {
  name        = "${var.vpc_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-vpc.id
  target_type = "ip"
}

# 
