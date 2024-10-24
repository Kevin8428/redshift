data "archive_file" "af" {
  type        = "zip"
  source_file = "../apps/redshift-copier/redshift-copier.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "lambdas/redshift-copier/${var.lambda_name}.zip"
  source = data.archive_file.af.output_path
  etag   = data.archive_file.af.output_md5
  tags   = var.tags
}

resource "aws_lambda_function" "f" {
  function_name     = var.lambda_name
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = "redshift-copier.main"
  timeout           = 30
  s3_bucket         = var.bucket_name
  s3_key            = aws_s3_bucket_object.object.id
  s3_object_version = aws_s3_bucket_object.object.version_id
  source_code_hash  = filebase64sha256(data.archive_file.af.output_path)

  depends_on = [
    aws_cloudwatch_log_group.lg,
  ]

  runtime = "python3.12"
  tags    = var.tags

  lifecycle {
    ignore_changes = [
      last_modified,
    ]
  }
}

resource "aws_cloudwatch_log_group" "lg" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
}
