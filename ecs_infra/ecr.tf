resource "aws_ecr_repository" "dagster_app" {
  name         = "dagster-app"
  force_delete = true
}

resource "aws_ecr_repository" "dagster_user_code" {
  name         = "dagster-user-code"
  force_delete = true
}

locals {
  user_code_md5   = md5(join("", concat([for file_path in fileset("${path.root}/../dbt_code", "**") : filemd5("${path.root}/../dbt_code/${file_path}")])))
  dagster_app_md5 = md5(join("", concat([for file_path in ["dagster.yaml", "workspace.yaml"] : filemd5("${path.root}/../dbt_code/orchestration/${file_path}")])))

}

# Data resources to get login information
data "aws_ecr_authorization_token" "auth" {}

resource "null_resource" "build_and_push_user_code" {
  provisioner "local-exec" {
    command = <<EOT
      ./build_and_push.sh ${aws_ecr_repository.dagster_user_code.name} ${aws_ecr_repository.dagster_user_code.repository_url} ${local.user_code_md5} "../dbt_code/orchestration/Dockerfile_code" "../dbt_code"
    EOT
  }

  depends_on = [aws_ecr_repository.dagster_user_code]
}

resource "null_resource" "build_and_push_dagster_app" {
  provisioner "local-exec" {
    command = <<EOT
      ./build_and_push.sh ${aws_ecr_repository.dagster_app.name} ${aws_ecr_repository.dagster_app.repository_url} ${local.dagster_app_md5} "../dbt_code/orchestration/Dockerfile_dagster" "../dbt_code/orchestration"
    EOT
  }

  depends_on = [aws_ecr_repository.dagster_app]
}



