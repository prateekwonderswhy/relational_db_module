provider "aws" {
  region = "ap-south-1"
}


module "mysql_db" {
  source = "../modules/rds"
  db_instance_identifier = var.db_instance_identifier
  db_instance_type       = var.db_instance_type
  db_username            = var.db_username
  db_password            = var.db_password
  use_case               = var.use_case
  role_arn               = module.mysql_db.role_arn
  max_allocated_storage  = var.max_allocated_storage
  engine_version         = var.engine_version
}
