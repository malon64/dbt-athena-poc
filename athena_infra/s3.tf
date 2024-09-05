resource "random_id" "bucket" {
  byte_length = 4
  keepers = {
    bucket_name = var.s3_bucket_name
  }
}
resource "aws_s3_bucket" "iceberg_data_bucket" {
  bucket        = "${var.s3_bucket_name}-${random_id.bucket.dec}"
  acl           = "private"
  force_destroy = true
}
