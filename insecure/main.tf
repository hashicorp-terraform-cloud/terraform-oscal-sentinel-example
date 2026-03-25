resource "random_uuid" "identifier" {}

resource "aws_s3_bucket" "this" {
  bucket = "insecure-bucket-${random_uuid.identifier.result}"
}
