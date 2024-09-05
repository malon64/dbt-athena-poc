resource "aws_athena_database" "dbt_database" {
  name          = var.athena_database_name
  bucket        = aws_s3_bucket.iceberg_data_bucket.bucket
  force_destroy = true
}
