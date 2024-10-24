variable "bucket_name" {
  type = string
  description = "kinesis storage location"
}

variable "lambda_arn" {
  type = string
  description = "lambda object for eventing"
}

variable "tags" {
  type = map(any)
  default = {}
}