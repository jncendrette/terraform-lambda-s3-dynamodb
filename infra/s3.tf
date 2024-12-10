resource "aws_s3_bucket" "data_bucket" {
  bucket        = join("-", [var.bucket_name, data.aws_caller_identity.user.account_id, var.env])
  force_destroy = true
  tags = {
    Name        = var.bucket_name
    Environment = var.env
  }
}