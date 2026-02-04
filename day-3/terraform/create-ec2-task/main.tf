provider "aws" {
  region = "eu-west-1"
  #   profile = "default"
  #   shared_config_files = ["~/.aws/config"]
  #   shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "se-dare-tf-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "se-dare-tf-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "se-dare-tf-private-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "se-dare-tf-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "se-dare-tf-public-rt"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "mongodb_sg" {
    name = "se-dare-private-subnet-mongodb-sg"
    description = "Allow access to MongoDB subnet from application subnet."
    vpc_id = aws_vpc.vpc.id

    ingress {
        # default SSH access
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.public_subnet.cidr_block]
    }

    tags = {
        Name = "se-dare-private-subnet-mongodb-sg"
    }
}

resource "aws_instance" "ec2_mongodb_instance" {

  ami = "ami-07753428b0d7737fb"
  instance_type = "t3.micro"
  key_name = "se-dare-key-pair"
  
  # Network settings
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  subnet_id = aws_subnet.private_subnet.id
  associate_public_ip_address = false

  tags = {
    Name = "se-dare-tf-mongodb-instance"
  }
}

resource "aws_security_group" "app_sg" {
    name = "se-dare-public-subnet-app-sg"
    description = "Allow internet and application traffic."
    vpc_id = aws_vpc.vpc.id

    ingress {
        # default SSH access
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }

    tags = {
        Name = "se-dare-public-subnet-app-sg"
    }
}

resource "aws_instance" "ec2_app_instance" {

  ami = "ami-0246312b3fe1e4ce6"
  instance_type = "t3.micro"
  key_name = "se-dare-key-pair"
  
  # Network settings
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "se-dare-tf-app-instance"
  }
}
