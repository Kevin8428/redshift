provider "aws" {
  region = "us-west-2"
  alias = "usw2"
}

terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }
}
