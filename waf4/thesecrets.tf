terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " 5.60.0"
    }
  }
}

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_files = ["C:\\Users\\dmit27\\.aws\\credentials"]
  #sensitive = true
}