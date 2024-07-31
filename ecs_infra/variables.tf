variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "dagster"
}

variable "app_environment" {
  description = "The environment of the application"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  type    = string
  default = "postgres_password"
}