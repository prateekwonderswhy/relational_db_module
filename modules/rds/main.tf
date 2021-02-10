terraform {
  required_version = ">= 0.13"
}

## RDS database configurations

resource "aws_db_instance" "default" {
  allocated_storage                     = var.allocated_storage
  storage_type                          = "gp2"
  identifier                            = var.db_instance_identifier
  engine                                = "mysql"
  port                                  = "3308"
  engine_version                        = var.engine_version
  performance_insights_enabled          = true
  copy_tags_to_snapshot                 = true
  skip_final_snapshot                   = true
  deletion_protection                   = true
  storage_encrypted                     = true
  maintenance_window                    = "Wed:04:00-Wed:05:00"
  max_allocated_storage                 = var.max_allocated_storage
  instance_class                        = var.db_instance_type
  name                                  = var.use_case
  username                              = var.db_username
  password                              = var.db_password
  parameter_group_name                  = "default.mysql${var.engine_version}"
  backup_retention_period               = 7
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.role_arn
  tags = {
    "Name" = var.use_case
  }
}


## IAM policy, role and policy attachment config for RDS

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



## Database Security Group Configurations

locals {
  ingress_rules = [{
    port           = 3308
    description    = "Port 3308"
  },
  {
    port           = 8080
    description    = "Port 8080"
  }
  ]

  egress_rules  = [{
    port           = 3308
    description    = "Port 3306"
  },
  {
    port           = 6379
    description    = "Port 6379"
  }
  ]

}



resource "aws_security_group" "PratilipiSG" {
  name        = "${var.use_case}-sg"
  vpc_id      = var.vpc_id


  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

  }

}