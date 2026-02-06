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
