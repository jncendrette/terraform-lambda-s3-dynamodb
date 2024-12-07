
provider "aws" {
  region  = var.region
  profile = "jonny"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "adacontabil-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.adacontabil.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_db_subnet_group" "adacontabil" {
  name       = "adacontabil"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "Ada Contabil"
  }
}

resource "aws_security_group" "rds" {
  name   = "adacontabil_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "adacontabil_rds"
  }
}


resource "aws_db_instance" "adacontabil" {
  identifier             = "adacontabil"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "ada"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.adacontabil.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = true
  skip_final_snapshot    = true


}

# resource "null_resource" "run_sql" {
#   provisioner "local-exec" {
#     command = <<EOT
#       mysqlsh -h ${aws_db_instance.adacontabil.address} -P 3306 -u ada -p ${var.db_password} < init.sql
#     EOT
#   }

#   depends_on = [aws_db_instance.adacontabil]
# }
