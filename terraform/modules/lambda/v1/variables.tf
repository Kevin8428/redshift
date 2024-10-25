variable "lambda_name" {
  type = string
  description = "lambda function name"
}

variable "subnet_id" {
  type = string
  description = "lambda deployed to subnet"
}

variable "security_group_id" {
  type = string
  description = "lambda sg"
}

variable "bucket_name" {
  type = string
  description = "bucket to place source code"
}

variable "tags" {
  type = map(any)
  default = {}
}