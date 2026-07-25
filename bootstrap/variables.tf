variable "aws_region" {
  description = "AWS region to create the state bucket (and lock table) in"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Project 9's remote Terraform state"
  type        = string
}

