resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_acl" "a" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}