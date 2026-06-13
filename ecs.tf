data "aws_ecr_repository" "flask_app" {
  name = "FlaskApp1"
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.vpc_name}-flask-app"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "flask-app"
      image     = "${data.aws_ecr_repository.flask_app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}


resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_ecs_service" "flask-App" {
  name            = "${var.vpc_name}-flask-app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2
  depends_on      = [aws_lb_listener.alb-listener-https]
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [
      aws_subnet.private1.id,
      aws_subnet.private2.id,
      aws_subnet.private3.id,
      aws_subnet.private4.id
    ]
    security_groups  = [aws_security_group.sg-ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "flask-app"
    container_port   = 5000
  }
}
