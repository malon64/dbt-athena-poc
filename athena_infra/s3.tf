resource "aws_s3_bucket" "iceberg_data_bucket" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = true
}
