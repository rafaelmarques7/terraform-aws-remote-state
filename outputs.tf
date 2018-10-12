output "s3_bucket" {
  description = "Information regarding the bucket created for Terraform state management"

  value {
    id                 = "${aws_s3_bucket.s3_bucket.id}"
    arn                = "${aws_s3_bucket.s3_bucket.arn}"
    bucket_domain_name = "${aws_s3_bucket.s3_bucket.bucket_domain_name}"
  }
}

output "dynamodb_table" {
  description = "Information regarding the dynamoDb table created for Terraform state lock management"

  value {
    id  = "${aws_dynamodb_table.dynamodb_table.id}"
    arn = "${aws_dynamodb_table.dynamodb_table.arn}"
  }
}

output "iam_user" {
  description = <<EOF
        Information regarding the IAM user account created to manage the terraform state bucket and table. 
        Note that the access keys must be created manualy in the AWS console.
    EOF

  value {
    arn  = "${aws_iam_user.iam_user.arn}"
    name = "${aws_iam_user.iam_user.name}"
    keys = "The access keys must be created manually on the AWS console!"
  }
}
