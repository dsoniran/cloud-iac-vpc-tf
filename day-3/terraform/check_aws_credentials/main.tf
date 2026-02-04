# Select the AWS provider --> downloads plugins to interact with AWS services
provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}