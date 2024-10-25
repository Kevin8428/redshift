resource "aws_cloudwatch_log_group" "lg" {
  name = "/aws/kinesisfirehose/${var.firehose_name}-delivery"
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "ls" {
  name           = "/aws/kinesisfirehose/${var.firehose_name}-stream"
  log_group_name = aws_cloudwatch_log_group.lg.name
}