# Provider AWS
provider "aws" {
  region  = "us-east-1"
  profile = "jonny"
}

# Criar o ZIP do arquivo Python
data "archive_file" "read_csv_zip" {
  type        = "zip"
  source_file = "${path.module}/read_csv.py"
  output_path = "${path.module}/read_csv.zip"
}

# Bucket S3 para armazenar o script e dados
resource "aws_s3_bucket" "data_bucket" {
  bucket = "adacontabil-767397788118-dev"
}

# Upload do script zipado para o S3
resource "aws_s3_object" "read_csv_script" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "scripts/read_csv.zip"
  source = data.archive_file.read_csv_zip.output_path
}

# Função Lambda
resource "aws_lambda_function" "read_csv" {
  function_name    = "read_csv_lambda"
  handler          = "read_csv.handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.read_csv_zip.output_path
  source_code_hash = data.archive_file.read_csv_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.id
    }
  }
}

# Recurso para permitir que o S3 invoque a Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_csv.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}

# Configuração do evento de S3 para disparar a Lambda
resource "aws_s3_bucket_notification" "bucket_trigger" {
  bucket = aws_s3_bucket.data_bucket.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.read_csv.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "input/"
    # filter_suffix       = ".csv"
  }
  depends_on = [aws_lambda_permission.allow_bucket, aws_s3_bucket.data_bucket]

}

