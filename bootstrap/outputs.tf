output "state_bucket_name" {
  description = "Name of the S3 bucket created for remote state — use this in the main project's backend.tf"
  value       = aws_s3_bucket.tf_state.id
}
