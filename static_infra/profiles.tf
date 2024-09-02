resource "local_file" "profiles" {
  content = templatefile("${path.module}/profiles_template.yml", {
    env = var.db_environment
    region = var.aws_region
    schema         = var.athena_database_name       
    database   = "awsdatacatalog"
    workgroup = "primary"
    s3_data_dir = "s3://${var.s3_bucket_name}/data/"
    s3_staging_dir = "s3://${var.s3_bucket_name}/staging/"
  })
  filename = "${path.module}/../athena_dbt_core/profiles.yml"
}

