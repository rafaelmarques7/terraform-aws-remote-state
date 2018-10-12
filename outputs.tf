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
