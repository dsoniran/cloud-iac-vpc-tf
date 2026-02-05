variable "region" {
  default     = "eu-west-1"
  description = "value"
}

variable "vpc_name" {
  default     = "se-dare-tf-instance"
  description = "value"
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "value"
}

variable "instance_tenancy" {
  default     = "default"
  description = "value"
}

variable "public_subnet_name" {
  default     = "se-dare-tf-public-subnet"
  description = "value"
}

variable "public_subnet_cidr_block" {
  default     = "10.0.2.0/24"
  description = "value"
}

variable "private_subnet_name" {
  default     = "se-daretf-private-subnet"
  description = "value"
}

variable "private_subnet_cidr_block" {
  default     = "10.0.3.0/24"
  description = "value"
}

variable "availability_zone_1" {
  default     = "eu-west-1a"
  description = "value"
}

variable "availability_zone_2" {
  default     = "eu-west-1b"
  description = "value"
}

variable "availability_zone_3" {
  default     = "eu-west-1c"
  description = "value"
}

variable "internet_gateway_name" {
  default     = "se-dare-tf-igw"
  description = "value"
}

variable "wildcard_cidr_block" {
  default     = "0.0.0.0/0"
  description = "value"
}

variable "public_route_table_name" {
  default     = "se-dare-tf-public-rt"
  description = "value"
}

variable "mongodb_sg_name" {
  default     = "se-dare-private-subnet-mongodb-sg"
  description = "value"
}

variable "mongodb_sg_description" {
  default     = "Allow access to MongoDB subnet from application subnet."
  description = "value"
}

variable "application_sg_name" {
  default     = "se-dare-public-subnet-application-sg"
  description = "value"
}

variable "app_sg_description" {
  default     = "Allow access to application subnet from the internet."
  description = "value"
}

variable "mongodb_instance_name" {
  default     = "se-dare-tf-mongodb-instance"
  description = "value"
}

variable "mongodb_ami" {
  default     = "ami-07753428b0d7737fb"
  description = "value"
}

variable "mongodb_allow_public_ip_address" {
  default = "false"
  description = "value"
}

variable "app_instance_name" {
  default     = "se-dare-tf-app-instance"
  description = "value"
}

variable "app_ami" {
  default     = "ami-0246312b3fe1e4ce6"
  description = "value"
}

variable "app_allow_public_ip_address" {
  default = "true"
  description = "value"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "value"
}

variable "key_pair" {
  default     = "se-dare-key-pair"
  description = "value"
}

variable "ssh_port" {
  default     = 22
  description = "value"
}

variable "mongodb_port" {
  default     = 27017
  description = "value"
}

variable "http_port" {
  default     = 80
  description = "value"
}

variable "other_port" {
  default     = 3000
  description = "value"
}

variable "protocol" {
  default     = "tcp"
  description = "value"
}