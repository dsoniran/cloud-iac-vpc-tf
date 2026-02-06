# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_instance" "ec2_app_instance_for_image" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = "ami-03446a3af42c5e74e" # Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type. Support available from Canonical
  instance_type = var.instance_type
  key_name      = var.key_pair

  # Network settings
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = var.app_allow_public_ip_address

  tags = {
    Name = var.app_instance_for_image_name
  }
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