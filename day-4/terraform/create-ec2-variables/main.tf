provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone_1

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.availability_zone_2

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.wildcard_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "mongodb_sg" {
  name        = var.mongodb_sg_name
  description = var.mongodb_sg_description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    # default SSH access
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = [var.wildcard_cidr_block]
  }

  ingress {
    from_port   = var.mongodb_port
    to_port     = var.mongodb_port
    protocol    = var.protocol
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  tags = {
    Name = var.mongodb_sg_name
  }
}

resource "aws_instance" "ec2_mongodb_instance" {

  ami           = var.mongodb_ami
  instance_type = var.instance_type
  key_name      = var.key_pair

  # Network settings
  vpc_security_group_ids      = [aws_security_group.mongodb_sg.id]
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = var.mongodb_allow_public_ip_address

  tags = {
    Name = var.mongodb_instance_name
  }
}

resource "aws_security_group" "app_sg" {
  name        = var.application_sg_name
  description = var.app_sg_description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    # default SSH access
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = [var.wildcard_cidr_block]
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.protocol
    cidr_blocks = [var.wildcard_cidr_block]
  }

  ingress {
    from_port   = var.other_port
    to_port     = var.other_port
    protocol    = var.protocol
    cidr_blocks = [var.wildcard_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.wildcard_cidr_block]
  }

  tags = {
    Name = var.application_sg_name
  }
}

resource "aws_instance" "ec2_app_instance" {

  ami           = var.app_ami
  instance_type = var.instance_type
  key_name      = var.key_pair

  # Network settings
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = var.app_allow_public_ip_address

  tags = {
    Name = var.app_instance_name
  }
}
