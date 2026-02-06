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

# resource "aws_imagebuilder_distribution_configuration" "app_image_distribution_configuration" {
#   name = "se-dare-tf-app-image-distribution-configuration"

#   distribution {
#     ami_distribution_configuration {
#       ami_tags = {
#         # CostCenter = "IT"
#       }

#       name = "se-dare-tf-app-image-{{ imagebuilder:buildDate }}"

#       launch_permission {
#         # user_ids = ["123456789012"]
#       }
#     }

#     # launch_template_configuration {
#       # launch_template_id = "lt-0aaa1bcde2ff3456"
#     # }

#     region = var.region
#   }
# }

# resource "aws_imagebuilder_component" "app_image_receipe_component" {
#   # data = yamlencode({
#   #   phases = [{
#   #     name = "build"
#   #     steps = [{
#   #       action = "ExecuteBash"
#   #       inputs = {
#   #         commands = ["echo 'hello world'"]
#   #       }
#   #       name      = "example"
#   #       onFailure = "Continue"
#   #     }]
#   #   }]
#   #   schemaVersion = 1.0
#   # })
#   name     = "se-dare-tf-app-image-recipe-component"
#   platform = "Linux"
#   version  = "1.0.0"
# }

# resource "aws_imagebuilder_image_recipe" "app_image_recipe" {
#   name = "se-dare-tf-app-image-recipe"
#   parent_image = var.app_ami
#   version = "1.0.0"

#   block_device_mapping {
#     device_name = "/dev/sda1"

#     ebs {
#       delete_on_termination = true
#       volume_size           = 8
#       volume_type           = "gp3"
#     }
#   }

#   component {
#     component_arn = aws_imagebuilder_component.app_image_receipe_component.arn
#   }

# }

# resource "aws_imagebuilder_infrastructure_configuration" "app_image_infrastructure_configuration" {
#   name = "se-dare-tf-app-image-infrastructure-configuration"
#   description = "Infrastructure configuration for application image"
#   instance_profile_name = "se-dare-tf-instance-profile"
#   instance_types = [var.instance_type]
#   key_pair = var.key_pair

#   # Network settings
#   security_group_ids = [aws_security_group.app_sg.id]
#   sns_topic_arn = "arn:aws:sns:eu-west-1:123456789012:my-sns-topic"
#   subnet_id = aws_subnet.public_subnet.id
#   terminate_instance_on_failure = true

#   tags = {
#     Name = "se-dare-tf-app-image-distribution-configuration"
#   }

# }

# resource "aws_imagebuilder_image" "app_image" {
#   distribution_configuration_arn = aws_imagebuilder_distribution_configuration.app_image_distribution_configuration.arn
#   image_recipe_arn = aws_imagebuilder_image_recipe.app_image_recipe.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.app_image_infrastructure_configuration.arn
# }

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

  # user_data = filebase64("${path.module}/user_data.sh")

  # user_data = base64encode(<<-EOF
  #     #!/bin/bash

  #     # enter directory with application script
  #     cd nodejs2-sparta-test-app-2025/app

  #     # install npm
  #     sudo npm install --yes

  #     # export database private ip address
  #     export DB_HOST="$(terraform output -raw db_host)"

  #     # kill any active operations
  #     pm2 kill

  #     # seed the data
  #     node seeds/seed.js

  #     # start app
  #     pm2 start app.js
  #   EOF
    # )

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