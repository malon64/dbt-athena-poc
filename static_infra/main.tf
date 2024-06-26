provider "aws" {
  region = "eu-west-1"  # Modifier selon votre région
}

resource "aws_s3_bucket" "iceberg_data_bucket" {
  bucket = "iceberg-data-bucket"
  acl = "private"
  force_destroy = true
}


# resource "aws_s3_object" "sample_data" {
#   bucket = aws_s3_bucket.iceberg_data_bucket.bucket
#   key    = "data/sample_data.csv"
#   source = "sample_data.csv"  # This file needs to be present locally
# }

resource "aws_athena_database" "dbt_database" {
  name   = "dbt_database"
  bucket = aws_s3_bucket.iceberg_data_bucket.bucket
  force_destroy = true
}

resource "aws_iam_role" "dbt_role" {
  name = "dbt-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "athena.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dbt_policy" {
  name        = "dbt-policy"
  description = "Policy for DBT to access S3 and Athena"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "glue:GetTable",
          "glue:GetTables",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dbt_role_policy_attachment" {
  role       = aws_iam_role.dbt_role.name
  policy_arn = aws_iam_policy.dbt_policy.arn
}

# resource "aws_athena_named_query" "create_sample_table" {
#   name      = "create_sample_table"
#   database  = aws_athena_database.dbt_database.name
#   query     = <<EOF
#     CREATE EXTERNAL TABLE IF NOT EXISTS dbt_database.sample_table (
#       id string,
#       name string,
#       value double,
#       date string
#     )
#     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
#     WITH SERDEPROPERTIES (
#       'serialization.format' = ','
#     ) LOCATION 's3://${aws_s3_bucket.iceberg_data_bucket.bucket}/data/'
#     TBLPROPERTIES ('has_encrypted_data'='false');
#   EOF
# }

# resource "null_resource" "execute_athena_query" {
#   depends_on = [aws_athena_named_query.create_sample_table]

#   provisioner "local-exec" {
#     command = <<EOT
#       aws athena start-query-execution --query-string "${aws_athena_named_query.create_sample_table.query}" --query-execution-context Database=${aws_athena_database.dbt_database.name} --result-configuration OutputLocation=s3://${aws_s3_bucket.iceberg_data_bucket.bucket}/results/
#     EOT
#   }
# }

