resource "aws_kms_key" "your_app_name" {
  description             = "Example Customer Master Key"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}


resource "aws_kms_alias" "your_app_name" {
  name          = "alias/example"
  target_key_id = aws_kms_key.your_app_name.key_id
}

