resource "aws_instance" "ec2_mongodb_instance" {

  ami           = var.mongodb_ami
  instance_type = var.instance_type
  #   key_name      = resource.aws_key_pair.key_pair.key_name
  key_name = var.key_pair

  # Network settings
  vpc_security_group_ids      = [aws_security_group.mongodb_sg.id]
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = var.mongodb_allow_public_ip_address

  tags = {
    Name = var.mongodb_instance_name
  }
}
