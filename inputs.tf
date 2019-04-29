variable "region" {
  description = "Region where the web servers will be created"
}

variable "webserver_port" {
  description = "The port the web servers will listen"
}

variable "keyname" {
  description = "Public key to connect to the web servers"
}

variable "public_key_path" {
  description = "Path to the public key for the web servers"
}

variable "owner" {
  description = "Email address of the web servers owner"
}

variable "department" {
  description = "Department responsible for the web servers"
}

variable "environment" {
  description = "Environment that these web servers will be part of"
}

variable "vpnip" {
  description = "IP address of the VPN server"
}

variable "ami" {
  description = "AMI to be used to create the web servers"
}

variable "ec2type" {
  description = "Type of EC2 instance for the web servers"
}

variable "vpc_cidr" {
  description = "Address space assigned to this VPC"
}

variable "subnet_cidrs" {
  description = "Address space assigned to the subnets where the web servers will be created"
  type = "list"
}

data "aws_availability_zones" "available_azs" {}