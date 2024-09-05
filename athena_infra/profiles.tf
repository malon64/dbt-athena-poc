resource "local_file" "profiles" {
  content = templatefile("${path.module}/profiles_template.yml", {
    env            = var.db_environment
    region         = var.aws_region
    schema         = var.athena_database_name
    database       = "awsdatacatalog"
    workgroup      = "primary"
    s3_data_dir    = "s3://${aws_s3_bucket.iceberg_data_bucket.bucket}/data/"
    s3_staging_dir = "s3://${aws_s3_bucket.iceberg_data_bucket.bucket}/staging/"
  })
  filename = "${path.module}/../dbt_code/profiles.yml"
}

