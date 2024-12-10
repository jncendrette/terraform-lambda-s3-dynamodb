resource "aws_dynamodb_table" "adacontabil" {
  name           = "adacontabil_tb"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 5

  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "Table Ada Contabil"
  }
}