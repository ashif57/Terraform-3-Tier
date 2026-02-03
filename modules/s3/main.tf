# ---------------------------
# S3 BUCKET
# ---------------------------
resource "aws_s3_bucket" "assets" {
  bucket = var.bucket_name

  tags = {
    Name = "photoshare-assets"
  }
}

# ---------------------------
# DEFAULT ENCRYPTION (AES-256)
# ---------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------
# BLOCK ALL PUBLIC ACCESS
# ---------------------------
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  ignore_public_acls     = true
  block_public_policy    = true
  restrict_public_buckets = true
}
