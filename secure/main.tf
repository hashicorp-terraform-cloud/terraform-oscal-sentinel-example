module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.11.0"

  bucket = "secure-bucket-example"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
