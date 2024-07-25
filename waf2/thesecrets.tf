terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "C:\\Users\\dmit27\\.aws\\credentials"
  #sensitive = true
}