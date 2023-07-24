terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.2"
    }
  }
}
