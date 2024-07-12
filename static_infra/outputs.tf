output "s3_bucket_name" {
  value = aws_s3_bucket.iceberg_data_bucket.bucket
}

output "athena_database_name" {
  value = aws_athena_database.dbt_database.name
}
