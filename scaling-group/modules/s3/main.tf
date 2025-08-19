locals {
  script_types = {
    backend = "backend_user_data.sh"
    frontend = "frontend_user_data.sh"
  }
}

resource "aws_s3_bucket" "script_buckets" {
  for_each = local.script_types
  bucket        = "${var.project_name}-${each.key}-userdata"
  force_destroy = (var.environment != "prod")
}

resource "aws_s3_object" "script" {
  for_each = local.script_types
  bucket = aws_s3_bucket.script_buckets[each.key].id
  key    = each.value
  source = "${path.root}/templates/${each.value}"
  etag   = filemd5("${path.root}/templates/${each.value}")
}

resource "aws_s3_bucket_versioning" "script_buckets" {
  for_each = aws_s3_bucket.script_buckets
  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "script_buckets" {
  for_each = aws_s3_bucket.script_buckets
  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "script_buckets" {
  for_each = aws_s3_bucket.script_buckets
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "script_buckets" {
  for_each = aws_s3_bucket.script_buckets
  bucket = each.value.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "no_public_access" {
  for_each = aws_s3_bucket.script_buckets

  bucket = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "DenyPublicAccess"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${each.value.arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
