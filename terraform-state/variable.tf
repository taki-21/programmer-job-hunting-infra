variable "aws_region" {
  default = "ap-northeast-1"
}
variable "aws_profile" {
  type    = string
  default = "default"
}

variable "s3_bucket_name" {
  type    = string
  default = "programmer-job-hunting-remote-state"
}

variable "dynamodb_name" {
  type    = string
  default = "programmer-job-hunting-state-lock"
}