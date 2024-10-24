variable "lambda_name" {
  type = string
  description = "lambda function name"
}

variable "tags" {
  type = map(any)
  default = {}
}