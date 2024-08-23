resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/dagster-dbt"
  retention_in_days = 7
}
resource "aws_ecs_service" "dagster_webserver_service" {
  name            = "${var.app_name}-webserver"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.dagster_webserver.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.webserver_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_lb.arn
    container_name   = "${var.app_name}-webserver"
    container_port   = 3000
  }
  service_registries {
    registry_arn = aws_service_discovery_service.dagster_webserver_service.arn
  }
  lifecycle {
    ignore_changes        = [desired_count, task_definition]
    create_before_destroy = true
  }
  triggers = {
    redeployment = plantimestamp()
  }
}

resource "aws_ecs_service" "dagster_daemon_service" {
  name            = "${var.app_name}-daemon"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.dagster_daemon.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.daemon_sg.id]
    assign_public_ip = true
  }
  service_registries {
    registry_arn = aws_service_discovery_service.dagster_daemon_service.arn
  }
  lifecycle {
    ignore_changes        = [desired_count, task_definition]
    create_before_destroy = true
  }
  triggers = {
    redeployment = plantimestamp()
  }
}

resource "aws_ecs_service" "dagster_usercode_service" {
  name            = "${var.app_name}-usercode"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.dagster_user_code.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.usercode_sg.id]
    assign_public_ip = true
  }
  service_registries {
    registry_arn = aws_service_discovery_service.dagster_usercode_service.arn
  }
  lifecycle {
    ignore_changes        = [desired_count, task_definition]
    create_before_destroy = true
  }
  triggers = {
    redeployment = plantimestamp()
  }
}


resource "aws_ecs_task_definition" "dagster_webserver" {
  family                   = "${var.app_name}-webserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = "2048"
  cpu                      = "1024"

  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-webserver"
      image     = "${aws_ecr_repository.dagster_app.repository_url}:latest"
      essential = true
      entryPoint = [
        "dagster-webserver",
        "-h",
        "0.0.0.0",
        "-p",
        "3000",
        "-w",
        "workspace.yaml"
      ]
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }]
      environment = [
        { name = "DB_HOST", value = aws_db_instance.dagster_postgres.address },
        { name = "DB_NAME", value = data.aws_ssm_parameter.db_name.value },
        { name = "DB_USERNAME", value = data.aws_ssm_parameter.db_username.value },
        { name = "DB_PORT", value = 5432 }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = data.aws_ssm_parameter.db_password.arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "dagster_daemon" {
  family                   = "${var.app_name}-daemon"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = "2048"
  cpu                      = "1024"

  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-daemon"
      image     = "${aws_ecr_repository.dagster_app.repository_url}:latest"
      essential = true
      entryPoint = [
        "dagster-daemon",
        "run"
      ]
      environment = [
        { name = "DB_HOST", value = aws_db_instance.dagster_postgres.address },
        { name = "DB_NAME", value = data.aws_ssm_parameter.db_name.value },
        { name = "DB_USERNAME", value = data.aws_ssm_parameter.db_username.value },
        { name = "DB_PORT", value = 5432 },
        { name = "DAGSTER_INSTANCE_IMAGE", value = "${aws_ecr_repository.dagster_app.repository_url}:latest" }

      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = data.aws_ssm_parameter.db_password.arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "dagster_user_code" {
  family                   = "${var.app_name}-user-code"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = "2048"
  cpu                      = "1024"

  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-user-code"
      image     = "${aws_ecr_repository.dagster_user_code.repository_url}:latest"
      essential = true
      environment = [
        { name = "DB_HOST", value = aws_db_instance.dagster_postgres.address },
        { name = "DB_NAME", value = data.aws_ssm_parameter.db_name.value },
        { name = "DB_USERNAME", value = data.aws_ssm_parameter.db_username.value },
        { name = "DB_PORT", value = 5432 },
        { name = "DAGSTER_CURRENT_IMAGE", value = "${aws_ecr_repository.dagster_user_code.repository_url}:latest" }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = data.aws_ssm_parameter.db_password.arn }
      ]
      portMappings = [{
        containerPort = 4000
        hostPort      = 4000
        protocol      = "tcp"
        appProtocol   = "grpc"
        name          = "dagster_user_code"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
