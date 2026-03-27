variable "aws_region" {
  type        = string
  description = "aws_region"
  default     = "eu-west-1"
}


variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "main-vpc"
}

variable "primary_az" {
  type        = string
  description = "primary availability zone"
  default     = "eu-west-1a"
}

variable "secondary_az" {
  type        = string
  description = "secondary availability zone"
  default     = "eu-west-1b"
}
