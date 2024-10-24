resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_notification" "n" {
  bucket = aws_s3_bucket.b.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.p]
}

resource "aws_lambda_permission" "p" {
  statement_id  = "AllowExecutionFromS3Bucket1"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.b.arn
}

# resource "aws_s3_bucket_acl" "a" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }