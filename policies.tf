# Create local variable for setting principals.identifiers
locals {
  accounts_arn = "${formatlist("arn:aws:iam::%s:root", var.list_account_ids)}"
}

# S3 policy 
#  - grant access to bucket and its files only 
#  - grant access to everyone in var.list_account_ids
data "aws_iam_policy_document" "iam_policy_document_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${local.accounts_arn}"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${local.accounts_arn}"]
    }
  }
}

# DynamoDB table policy 
#  - grant access table only
#  - grant access to everyone in var.list_account_ids
data "aws_iam_policy_document" "iam_policy_document_dynamodb" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table:${var.dynamodb_table_name}"]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${local.accounts_arn}"]
    }
  }
}
