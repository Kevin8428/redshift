variable "s3_bucket_arn" {
  type        = string
  description = "kinesis storage location"
}

variable "kinesis_stream" {
  # type        = map
  type = object({
    arn                       = string
    encryption_type           = string
    enforce_consumer_deletion = bool
    id                        = string
    kms_key_id                = string
    name                      = string
    retention_period          = number
    shard_count               = number
    shard_level_metrics       = list(string)
    stream_mode_details       = list(map(any))
    tags                      = map(any)
    tags_all                  = map(any)
    timeouts                  = map(any)
  })
  description = "kinesis stream"
}

variable "firehose_name" {
  type        = string
  description = "firehose stream name"
}

# variable "glue_catalog_table" {
#   type    = map
#   default = {}
# }

variable "tags" {
  type    = map(any)
  default = {}
}
