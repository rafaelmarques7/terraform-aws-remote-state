variable "remote_state_file_name" {
  type        = "string"
  description = "The name for the file where the remote state is saved"
  default     = "state_terraform"
}

variable "region" {
  type        = "string"
  description = "The AWS region where the terraform stack is created"
  default     = "us-east-1"
}
