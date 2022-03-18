variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}
variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI's profile"
}
variable "app_name" {
  type    = string
  default = "programmer-job-hunting"
}

variable "domain" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "master_key" {}
