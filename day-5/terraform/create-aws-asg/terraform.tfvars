# Provider details
region = "eu-west-1"

# VPC details
vpc_name         = "se-dare-tf-instance"
vpc_cidr_block   = "10.0.0.0/16"
instance_tenancy = "default"

# Public subnet details
public_subnet_name          = "se-dare-tf-public-subnet"
public_subnet_cidr_block    = "10.0.2.0/24"
application_sg_name         = "se-dare-tf-application-sg"
app_sg_description          = "Security group for application instance in the public subnet"
app_instance_name           = "se-dare-tf-application-instance"
app_ami                     = "ami-0246312b3fe1e4ce6" # tech516-luke-node20-app-image
app_allow_public_ip_address = true
http_port                   = 80
other_port                  = 3000

# Private subnet details
private_subnet_name             = "se-daretf-private-subnet"
private_subnet_cidr_block       = "10.0.3.0/24"
mongodb_sg_name                 = "se-dare-tf-mongodb-sg"
mongodb_sg_description          = "Security group for MongoDB instance in the private subnet"
mongodb_instance_name           = "se-dare-tf-mongodb-instance"
mongodb_ami                     = "ami-07753428b0d7737fb" # tech516-luke-mongodb-image
mongodb_allow_public_ip_address = false
mongodb_port                    = 27017

# Internet Gateway details
internet_gateway_name = "se-dare-tf-igw"

# Public route table details
public_route_table_name = "se-dare-tf-public-route-table"

# Common details
instance_type       = "t3.micro"
key_pair            = "se-dare-key-pair"
ssh_port            = 22
protocol            = "tcp"
wildcard_cidr_block = "0.0.0.0/0"

## Image Builder details
app_instance_for_image_name = "se-dare-tf-app-instance-for-image"
