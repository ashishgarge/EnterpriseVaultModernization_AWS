terraform {
  required_providers {
    aws = {
      version = "= 5.33.0"
    }
  }
  backend "s3" {
    bucket       = "ev-modernization-terraform-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}