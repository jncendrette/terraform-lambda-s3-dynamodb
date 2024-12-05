resource "aws_s3_bucket" "default" {
  bucket = join("-", [var.bucket_name, data.aws_caller_identity.user.account_id])

  tags = {
    Name        = var.bucket_name
    Environment = var.env
  }
}