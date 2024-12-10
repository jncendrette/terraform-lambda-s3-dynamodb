variable "bucket_name" {
  type = string
}

variable "env" {
  description = "Environment where this module is invoked."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"

}