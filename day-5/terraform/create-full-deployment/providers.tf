terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
