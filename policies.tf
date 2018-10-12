data "aws_iam_policy_document" "iam_policy_document_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.iam_user.arn}"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.iam_user.arn}"]
    }
  }
}

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
      identifiers = ["${aws_iam_user.iam_user.arn}"]
    }
  }
}
