variable "enabled" {
  type        = bool
  description = "toggle deploy"
}

variable "cluster_name" {
  type        = string
  description = "firehose stream name"
}

variable "master_username" {
  type        = string
  description = ""
}

variable "master_password" {
  type        = string
  description = ""
}

variable "node_type" {
  type        = string
  description = ""
}

variable "cluster_type" {
  type        = string
  description = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}
