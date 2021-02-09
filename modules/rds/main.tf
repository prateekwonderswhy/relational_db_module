terraform {
  required_version = ">= 0.13"
}

resource "aws_db_instance" "default" {
  allocated_storage       = 20
  storage_type            = "gp2"
  identifier              = var.db_instance_identifier
  engine                  = "mysql"
  port                    = "3308"
  engine_version          = "5.7"
  performance_insights_enabled = true
  skip_final_snapshot     = true
  instance_class          = var.db_instance_type
  name                    = var.use_case
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql5.7"
  backup_retention_period = 7
  monitoring_interval = 30
  monitoring_role_arn = var.role_arn
  tags = {
    "Name" = var.use_case
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
  tags = {
    "Name" = var.use_case
  }
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
