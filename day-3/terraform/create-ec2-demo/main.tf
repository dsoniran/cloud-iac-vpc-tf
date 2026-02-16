provider "aws" {
  region = "eu-west-1"
  #   profile = "default"
  #   shared_config_files = ["~/.aws/config"]
  #   shared_credentials_files = ["~/.aws/credentials"]
}

# Which resource do we want to create?
resource "aws_instance" "test_instance_1" {

  # AMI_ID
  ami = "ami-03446a3af42c5e74e"

  # Instance Type
  instance_type = "t3.micro"

  # add public IP
  associate_public_ip_address = true

  # Tags // Name of the instance
  tags = {
    Name = "se-dare-tf-instance"
  }
}
