resource "random_uuid" "identifier" {}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.11.0"

  bucket = "insecure-bucket-${random_uuid.identifier.result}"
}
