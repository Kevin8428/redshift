variable "vpc" {
  type        = map
  description = "vpc object"
}

variable "tags" {
  type = map(any)
  default = {}
}