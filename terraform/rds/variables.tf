variable "app_name" {}

variable "vpc_id" {}

variable "alb_security_group" {}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.20"
}

variable "db_instance" {
  type    = string
  default = "db.t2.micro"
}

variable "private_subnet_ids" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}
