output "frontend_script" {
    description = "S3 bucket name with frontend script"
    value = aws_s3_bucket.script_buckets["frontend"].bucket
}

output "backend_script" {
    description = "S3 bucket name with backend script"
    value = aws_s3_bucket.script_buckets["backend"].bucket
}