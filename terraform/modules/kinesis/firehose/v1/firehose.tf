resource "aws_kinesis_firehose_delivery_stream" "s" {
  name        = var.firehose_name
  destination = "extended_s3" # no lambda required

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = var.s3_bucket_arn

    buffering_interval = 10

    processing_configuration {
      enabled = "true"
      # New line delimiter processor example
      processors {
        type = "AppendDelimiterToRecord"
      }

    }
    
    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = aws_cloudwatch_log_group.lg.name
      log_stream_name = aws_cloudwatch_log_stream.ls.name
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream.arn
    role_arn           = aws_iam_role.firehose.arn
  }

  tags = var.tags
}
