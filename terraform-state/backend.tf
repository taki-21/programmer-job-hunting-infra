resource "aws_s3_bucket" "terraform-state" {
  bucket = var.s3_bucket_name
  # terraform destroyによって削除されないよう設定
  # lifecycle {
  #   prevent_destroy = true
  # }
  # AES256でファイルを暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Terraform = "true"
    Name      = "terraform"
  }
}

resource "aws_dynamodb_table" "programmer-job-hunting-state-lock" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # 値はLockIDである必要がある
  attribute {
    name = "LockID" # 値はLockIDである必要がある
    type = "S"
  }
  tags = {
    Terraform = "true"
    Name      = "terraform"
  }
}