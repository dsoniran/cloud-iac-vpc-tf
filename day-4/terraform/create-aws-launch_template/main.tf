# terraform import aws_key_pair.se-dare-tf-key se-dare-tf-key-pair

provider "aws" {
  region = var.region
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

resource "aws_launch_template" "launch_template" {
  name = "se-dare-tf-launch-template"
  description = "Launch template for ASG"
  image_id           = var.app_ami
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

  # user_data = filebase64("${path.module}/user_data.sh")

  ## db_host incorrect on app instance deployment
   ## db_host incorrect on app instance deployment
  ## because the launch template is created before the MongoDB instance, so the DB_HOST value is captured at that time and is incorrect when the application instance is launched. To fix this, we can modify the user data script to fetch the MongoDB instance's private IP address dynamically at runtime instead of hardcoding it during launch template creation. This way, when the application instance starts up, it will retrieve the correct DB_HOST value and be able to connect to the MongoDB instance successfully, regardless of when the launch template was created.
  ## likely due to se-luke-nodejs-app-2025
  ## bashrc resets the DB_HOST variable to the value at the time of launch template creation, which is before the MongoDB instance is created and its private IP address is available. As a result, the DB_HOST variable in the user data script contains an incorrect value when the application instance is launched. To resolve this issue, we can update the user data script to fetch the MongoDB instance's private IP address dynamically at runtime instead of hardcoding it during launch template creation. This way, the application instance will always have the correct DB_HOST value when it starts up, regardless of when the MongoDB instance is created. The user data script can be modified to include a command that retrieves the MongoDB instance's private IP address using the AWS CLI or by querying the instance metadata service, ensuring that the application instance can connect to the MongoDB instance successfully even if the launch template is created before the MongoDB instance.     The issue arises because the user data script in the launch template is created before the MongoDB instance is launched, and it captures the DB_HOST value at that time. Since the MongoDB instance's private IP address is not available when the launch template is created, the DB_HOST variable in the user data script contains an incorrect value. When the application instance is launched using this launch template, it tries to connect to the MongoDB instance using the incorrect DB_HOST value, resulting in a connection failure. To fix this issue, we can modify the user data script to fetch the MongoDB instance's private IP address dynamically at runtime instead of hardcoding it during launch template creation. This way, when the application instance starts up, it will retrieve the correct DB_HOST value and be able to connect to the MongoDB instance successfully, regardless of when the launch template was created.
  # after the launch template. To fix this, we can use a placeholder value and then update it after the ASG is created.

  user_data = base64encode(<<-EOF
      # enter directory with application script
      cd nodejs2-sparta-test-app-2025/app

      # install npm
      sudo npm install --yes

      # export database private ip address
      export DB_HOST="$(terraform output -raw db_host)"

      # kill any active operations
      pm2 kill

      # seed the data
      node seeds/seed.js

      # start app
      pm2 start app.js
    EOF
    )

    depends_on = [ 
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
}