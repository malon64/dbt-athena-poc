
data "aws_caller_identity" "current" {}


# Retrieve secrets from AWS Parameter Store
data "aws_ssm_parameter" "db_name" {
  name = "/dev/dagster/postgres/DB_NAME"
}

data "aws_ssm_parameter" "db_username" {
  name = "/dev/dagster/postgres/DB_USERNAME"
}

data "aws_ssm_parameter" "db_password" {
  name = "/dev/dagster/postgres/DB_PASSWORD"
}

data "aws_ssm_parameter" "db_port" {
  name = "/dev/dagster/postgres/DB_PORT"
}