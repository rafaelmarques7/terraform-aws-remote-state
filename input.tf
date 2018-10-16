variable "aws_access_key" {
  type        = "string"
  description = "The AWS account access key (id)."
}

variable "aws_secret_key" {
  type        = "string"
  description = "The AWS account secret key (password)."
}

variable "bucket_name" {
  type        = "string"
  description = "The name for the bucket where the remote state is saved."
}

variable "dynamodb_table_name" {
  type        = "string"
  description = "The name of the DynamoDb table used to lock the state."
}

variable "list_account_ids" {
  type        = "list"
  description = "A list containing IDs of account that may access the state."
}

variable "account_id" {
  type        = "string"
  description = "The ID number of the account to where the state is being deployed."
}
