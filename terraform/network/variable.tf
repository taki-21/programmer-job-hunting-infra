variable "app_name" {}

variable "vpc_cidr" {
  default = "135.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["135.0.0.0/24", "135.0.1.0/24", "135.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  default = ["135.0.10.0/24", "135.0.11.0/24", "135.0.12.0/24"]
}
variable "azs_name" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}
