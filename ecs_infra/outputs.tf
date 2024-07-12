data "aws_network_interface" "interface_tags" {
  filter {
    name   = "tag:aws:ecs:serviceName"
    values = ["${aws_ecs_service.dagster_dbt.name}"]
  }
  depends_on = [aws_ecs_service.dagster_dbt]
}

output "ecr_repository_url" {
  value = aws_ecr_repository.dagster_dbt_app.repository_url
}

output "ecs_service_url" {
  value       = "http://${data.aws_network_interface.interface_tags.association[0].public_ip}:3000"
  description = "The URL of the ECS service"
}
