
variable "db_name" {
  type        = string
  description = "Glue apps name"
}

variable "tags" {
  type    = map(any)
  default = {}
}
