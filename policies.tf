resource "aws_iam_policy" "iam_policy" {
  name   = "PolicyTerraformRemoteState"
  policy = "${data.aws_iam_policy_document.iam_policy_document_iam_user.json}"
}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "this can not be an empty string"
  users      = ["${aws_iam_user.iam_user.name}"]
  policy_arn = "${aws_iam_policy.iam_policy.arn}"
}

data "aws_iam_policy_document" "iam_policy_document_iam_user" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table:${var.dynamodb_table_name}"]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
  }
}

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
