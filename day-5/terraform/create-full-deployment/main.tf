# Configure the AWS provider
provider "aws" {
  region = var.region
}

# Configure the GitHub provider
provider "github" {
    token = var.github_token
}

# resource "aws_key_pair" "key_pair" {
#   key_name = "se-dare-tf-key-pair"
#     public_key = file("~/.ssh/se-dare-tf-key-pair.pub")
# }

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
  availability_zone = "${var.region}a"

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "${var.region}b"

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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251022"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_app_instance_for_image" {
  ami           = data.aws_ami.ubuntu.id
  # ami           = "ami-049442a6cf8319180" # Canonical, Ubuntu, 24.04, amd64 noble image
  instance_type = var.instance_type
  key_name      = var.key_pair

  # Network settings
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = var.app_allow_public_ip_address

  tags = {
    Name = var.app_instance_for_image_name
  }


  # user_data_base64 = base64encode(file("${path.module}/deploy_app.sh"))

  user_data_base64 = base64encode(
    templatefile("${path.module}/deploy_app.sh", {
      github_token = var.github_token
    })
  )
}

resource "aws_ami_from_instance" "ami_from_instance" {
  name               = "se-dare-tf-app-image-from-instance"
  source_instance_id = aws_instance.ec2_app_instance_for_image.id
  depends_on         = [aws_instance.ec2_app_instance_for_image]
}

resource "aws_launch_template" "launch_template" {
  name = "se-dare-tf-launch-template"
  description = "Launch template with terraform"
  image_id           = aws_ami_from_instance.ami_from_instance.id
  instance_type      = var.instance_type
  key_name = var.key_pair

  placement {
    availability_zone = "${var.region}a"
  }

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = var.app_allow_public_ip_address
  }

    user_data = base64encode(
      templatefile("${path.module}/user_data.sh", {
        db_host = "mongodb://${aws_instance.ec2_mongodb_instance.private_ip}:27017/posts"
      })
    )

    depends_on = [ 
      aws_ami_from_instance.ami_from_instance,
      aws_instance.ec2_mongodb_instance
     ]
}

resource "aws_instance" "app_instance_from_template" {
  count = 1

  launch_template {
    id = resource.aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tags = {
    Name = "se-dare-app-from-template"
  }

  depends_on = [ aws_launch_template.launch_template ]
}
