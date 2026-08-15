output "state_bucket_name" {
  description = "S3 bucket created for remote state"
  value       = aws_s3_bucket.tf_state.id
}
