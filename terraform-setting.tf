terraform {
  required_version = "~> 1.0.9"
  required_providers {
    aws = {
      version = ">= 3.63.0"
      source = "hashicorp/aws"
    }
  }
}
