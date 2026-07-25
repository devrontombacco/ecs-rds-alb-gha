terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # This config's own state stays local (or you can leave it untracked).
  # It exists solely to create the bucket (and optionally the lock table)
  # that the *main* project's remote backend depends on.
}

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------
# S3 bucket to hold Project 9's remote Terraform state
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  # Prevents accidental deletion via `terraform destroy` on this bootstrap
  # config. Remove this if you're sure you want destroy to be able to
  # remove the bucket.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# No DynamoDB lock table needed — Terraform 1.15.8 supports native S3
# locking. Set use_lockfile = true in the main project's backend.tf instead.
