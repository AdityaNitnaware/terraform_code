terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  access_key = ""
  secret_key = ""
}