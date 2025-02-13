
# With Versioning Enabled

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Owner       = "example@example.com"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.status
  }
}

# aws_s3_bucket_lifecycle_configuration

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = var.s3_bucket_name
  rule {
    id     = "${var.s3_bucket_name}-lifecycle"
    status = "Enabled"

    expiration {
      days = var.expiry_days
    }

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 60
    }
  }
}

