terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.36.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}