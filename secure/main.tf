resource "random_uuid" "identifier" {}

resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "s3" {
  name          = "alias/secure-bucket-${random_uuid.identifier.result}"
  target_key_id = aws_kms_key.s3.key_id
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.11.0"

  bucket = "secure-bucket-${random_uuid.identifier.result}"

  # SC-28.1 — KMS encryption at rest
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
      bucket_key_enabled = true
    }
  }

  # Policy 1 — block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Policy 5 — versioning
  versioning = {
    enabled = true
  }
}

# Policy 3 — EventBridge notifications
resource "aws_s3_bucket_notification" "eventbridge" {
  bucket      = module.s3-bucket.s3_bucket_id
  eventbridge = true
}
