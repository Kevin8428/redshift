variable "bucket_name" {
  type = string
  description = "kinesis storage location"
}

variable "tags" {
  type = map(any)
  default = {}
}