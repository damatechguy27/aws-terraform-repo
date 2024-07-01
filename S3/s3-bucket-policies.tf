resource "aws_s3_bucket" "example_bucket" {
  bucket = "awsdams3testbucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle_policy" {
#enter the id of the s3 bucket
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    id     = "delete-all-after-30-days"
    status = "Enabled"

    #filters out the only 
    filter {
        prefix = "backup/"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 30
    }

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
