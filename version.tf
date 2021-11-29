terraform {
  required_version = ">= 1.0.0"
  # backend "s3" {
  # }
}

provider "aws" {
  region = "us-east-1"
}