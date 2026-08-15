variable "aws_region" {
  description = "AWS region for state bucket"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

