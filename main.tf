locals {
  env         = "dev"
  bucket_name = "adacontabil"
}

module "s3" {
  source = "./s3-module"

  env         = local.env
  bucket_name = local.bucket_name
}

# module "vpc" {
#   source = "./vpc-module"

# }

module "lambda" {
  source = "./lambda-module"

}

module "rds" {
  source      = "./rds-module"
  db_password = var.db_password

}

module "sns-sqs" {
  source = "./sns-sqs-module"

}