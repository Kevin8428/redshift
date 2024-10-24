resource "aws_kinesis_stream" "s" {
  name             = var.stream_name
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = var.tags
}
