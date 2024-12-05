locals {
  env         = "dev"
  bucket_name = "adacontabil"
}

module "s3" {
  source = "../s3-module"

  env         = local.env
  bucket_name = local.bucket_name
}

module "vpc" {
  source = "../vpc-module"

}