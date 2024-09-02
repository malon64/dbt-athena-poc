variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "db_environment" {
  description = "The Database environment (dev, prod or staging)"
  type = string
  default = "dev"
  validation {
    condition     = length(regexall("^(dev|staging|prod)$", var.db_environment)) > 0
    error_message = "ERROR: Valid types are \"dev\" , \"staging\" or \"prod\"!"
  }
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

