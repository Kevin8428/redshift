variable "stream_name" {
  type = string
  description = "kinesis stream name"
}

variable "tags" {
  type = map(any)

  default = {}
}