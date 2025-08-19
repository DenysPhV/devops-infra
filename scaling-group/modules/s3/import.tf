
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid    = "AllowCrossAccount"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.external_account_arn]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      # for key, bucket in aws_s3_bucket.script_buckets : "${bucket.arn}/*"
      aws_s3_bucket.script_buckets["backend"].arn,
      aws_s3_bucket.script_buckets["frontend"].arn,
    ]
  }
}


