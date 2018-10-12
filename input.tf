variable "aws_access_key" {
  type        = "string"
  description = "The AWS account access key (id)"
}

variable "aws_secret_key" {
  type        = "string"
  description = "The AWS account secret key (password)"
}

variable "bucket_name" {
  type        = "string"
  description = "The name for the bucket where the remote state is saved"
}

variable "dynamodb_table_name" {
  type        = "string"
  description = "The name of the DynamoDb table used to lock the state"
}

variable "dev_id" {
  type        = "string"
  description = "The ID number of the DEV account"
}

variable "prod_id" {
  type        = "string"
  description = "The ID number of the PROD account"
}

variable "stage_id" {
  type        = "string"
  description = "The ID number of the STAGING account"
}

variable "account_id" {
  type        = "string"
  description = "The ID number of the account where the state is being deployed to"
}
