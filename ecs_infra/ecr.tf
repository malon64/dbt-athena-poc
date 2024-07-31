resource "aws_ecr_repository" "dagster_app" {
  name         = "dagster-app"
  force_delete = true
}

resource "aws_ecr_repository" "dagster_user_code" {
  name         = "dagster-user-code"
  force_delete = true
}


# Data resources to get login information
data "aws_ecr_authorization_token" "auth" {}

resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      ./build_and_push.sh ${aws_ecr_repository.dagster_app.repository_url} ${aws_ecr_repository.dagster_user_code.repository_url}
    EOT
  }

  depends_on = [aws_ecr_repository.dagster_app, aws_ecr_repository.dagster_user_code]
}



