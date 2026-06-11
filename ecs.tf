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
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}
