# ALB SG 
resource "aws_security_group" "sg-alb" {
  name        = "alb sg"
  description = "Allow http + https"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-sg-alb"
  }

}


# ECS SG
resource "aws_security_group" "sg-ecs" {
  name        = "ecs sg"
  description = "Allow http from alb"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-sg-ecs"
  }

}


# RDS SG 
resource "aws_security_group" "sg_rds" {
  name        = "rds sg"
  description = "Allow PostgreSQL access from ECS tasks"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-ecs.id]
  }

  tags = {
    Name = "${var.vpc_name}-sg_rds"
  }

}
