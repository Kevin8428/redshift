variable "tags" {
  type = map(any)
  default = {}
}

variable "cidr_block" {
  type = string
}