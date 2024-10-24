variable "s3_bucket" {
  type        = map
  description = "kinesis storage location"
}

variable "stream_name" {
  type        = map
  description = "kinesis stream"
}

variable "firehose_name" {
  type = string
  description = "firehose stream name"
}

variable "tags" {
  type = map(any)
  default = {}
}