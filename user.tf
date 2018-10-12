resource "aws_iam_user" "iam_user" {
  name = "${var.username_terraform}"
}
