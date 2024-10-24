variable "lambda_name" {
  type = string
  description = "lambda function name"
}

variable "bucket_name" {
  type = string
  description = "bucket to place source code"
}

variable "tags" {
  type = map(any)
  default = {}
}