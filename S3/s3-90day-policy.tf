resource "aws_s3_bucket" "s3_bucket" {
  bucket = "awsdams3testbucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle_policy" {
#enter the id of the s3 bucket
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "transition-and-delete-rule"
    status = "Enabled"

    transition {
      days          = 15
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 90
    }
  }
}