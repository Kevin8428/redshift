variable "enabled" {
  type        = bool
  description = "toggle deploy"
}

variable "cluster_name" {
  type        = string
  description = "firehose stream name"
}

variable "availability_zone" {
  type        = string
  description = "az for cluster"
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

variable "subnet_ids" {
  type        = list(any)
  description = "subnets within VPC eligible for cluster"
}

variable "security_group_ids" {
  type = list(any)
}

variable "tags" {
  type    = map(any)
  default = {}
}
