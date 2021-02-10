variable "db_instance_identifier" {
    type = string
}

variable "db_instance_type" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "use_case" {
    type = string
}

variable "max_allocated_storage" {
  type = number
}

variable "engine_version" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "monitoring_interval" {
  type = number
  default = 0
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_cidr_block" {
  type = string
}
