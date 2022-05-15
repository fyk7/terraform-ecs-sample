variable "name" {}
variable "policy" {}
variable "identifier" {}


# IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


# IAM Policy
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}


# Role <-> Policy Attachment
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}


# output
output "iam_role_arn" {
  value = aws_iam_role.default.arn
}
output "iam_role_name" {
  value = aws_iam_role.default.name
}
