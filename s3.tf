# Create S3 bucket 
#   - enable versioning     (backups)
#   - apply policies        (security)
#   - apply encription      (security)
#   - apply prevent_destroy (robustness)
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
  policy = "${data.aws_iam_policy_document.iam_policy_document_s3.json}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Add one file - not required - this is used to verify the policies work properly
resource "aws_s3_bucket_object" "index_page" {
  bucket       = "${aws_s3_bucket.s3_bucket.bucket}"
  key          = "README.md"
  source       = "README.md"
  content_type = "text/html"
}
