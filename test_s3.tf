
variable "test_bucket_name" {
  type    = string
  default = "test-bucket-darrell"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = var.test_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "test_index" {
  key        = "index.html"
  bucket     = aws_s3_bucket.test_bucket.id
  source     = "${path.module}/index.html"
#   kms_key_id = aws_kms_key.kms.arn
}

# resource "aws_s3_object" "test_nginx" {
#   key        = "nginx.conf"
#   bucket     = aws_s3_bucket.test_bucket.id
#   source     = "${path.module}/nginx.conf"
# #   kms_key_id = aws_kms_key.kms.arn
# }

# If needed. KMS for encryption
# resource "aws_kms_key" "kms" {
#   description             = "KMS key 1"
#   deletion_window_in_days = 7
# }
