resource "aws_s3_bucket" "load-balancer-logs-bucket" {
  bucket = "obsidian-load-balancer-logs-sandbox"

  tags = {
    Name        = "load-balancer-logs-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "load-balancer-logs-bucket" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "load-balancer-logs" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket     = aws_s3_bucket.load-balancer-logs-bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.load-balancer-logs]
}

### S3 Bucket Frontend ###
resource "aws_s3_bucket" "frontend" {
  bucket = "obsidian-frontend-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-fontend-bucket-ownership-controls" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl_frontend" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-fontend-bucket-ownership-controls]

  bucket = aws_s3_bucket.frontend.id
  acl    = "private"
}
