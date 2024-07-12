variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "iceberg-data-bucket"
}

variable "athena_database_name" {
  description = "The name of the Athena database"
  type        = string
  default     = "dbt_database"
}

