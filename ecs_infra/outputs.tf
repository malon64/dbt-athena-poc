output "webserver_dns" {
  description = "The DNS name of the ALB"
  value       = "http://${aws_lb.ecs_lb.dns_name}"
}