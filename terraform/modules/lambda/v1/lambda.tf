data "archive_file" "af" {
  type        = "zip"
  source_file = "../apps/redshift-copier/redshift-copier.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "f" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "redshift-copier.main"
  timeout       = 30

  depends_on = [
    aws_cloudwatch_log_group.lg,
  ]

  source_code_hash = data.archive_file.af.output_base64sha256
  runtime = "python3.12"
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lg" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
}