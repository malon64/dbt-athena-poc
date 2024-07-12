resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/dagster-dbt"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "dagster_dbt" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = "1024"
  cpu                      = "512"

  container_definitions = jsonencode([
    {
      name      = "dagster-dbt-container"
      image     = "${aws_ecr_repository.dagster_dbt_app.repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/dagster-dbt"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

resource "aws_ecs_service" "dagster_dbt" {
  name                    = "${lower(var.app_name)}-${lower(var.app_environment)}-service"
  cluster                 = aws_ecs_cluster.main.id
  task_definition         = aws_ecs_task_definition.dagster_dbt.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  wait_for_steady_state   = true
  enable_ecs_managed_tags = true
  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}
