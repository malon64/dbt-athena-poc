resource "aws_ecr_repository" "dagster_dbt_app" {
  name         = "dagster-dbt-app"
  force_delete = true
}

# Data resources to get login information
data "aws_ecr_authorization_token" "auth" {}

resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = "./build_and_push.sh ${aws_ecr_repository.dagster_dbt_app.repository_url}"
  }

  depends_on = [aws_ecr_repository.dagster_dbt_app]
}
