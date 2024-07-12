variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "dagster-dbt-app"
}

variable "app_environment" {
  description = "The environment of the application"
  type        = string
  default     = "dev"
}
