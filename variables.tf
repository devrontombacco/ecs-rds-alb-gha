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

variable "domain_name" {
  type        = string
  description = "Domain for my app"
  default     = "myawsproject.xyz"
}

// DB VARIABLES

variable "db_name" {
  description = "PostgreSQL db name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for RDS instance"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for RDS instance"
  type        = string
  sensitive   = true
}
