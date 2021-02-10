provider "aws" {
  region = "ap-south-1"
}


## VPC and Subnet Configurations

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.use_case
  }
}

resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = var.use_case
  }
}

module "mysql_db" {
  source = "../modules/rds"
  db_instance_identifier = var.db_instance_identifier
  db_instance_type       = var.db_instance_type
  allocated_storage      = var.allocated_storage
  db_username            = var.db_username
  db_password            = var.db_password
  use_case               = var.use_case
  role_arn               = module.mysql_db.role_arn
  max_allocated_storage  = var.max_allocated_storage
  engine_version         = var.engine_version
  monitoring_interval    = var.monitoring_interval
  vpc_id                 = aws_vpc.main.id
}
