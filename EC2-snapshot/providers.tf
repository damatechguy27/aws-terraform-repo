terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.46.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-west-2"

    # linux 
    #shared_credentials_files = "~/.aws/credentials"
    #window
    shared_credentials_files = ["C:\\Users\\user1\\.aws\\credentials"]

    profile = "default"
}

