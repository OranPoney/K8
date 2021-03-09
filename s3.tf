module "s3_backup_bucket" {
  count = var.kubernetes_backup_bucket_create ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.kubernetes_backup_bucket_name
  acl    = "private"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = var.tags
}
