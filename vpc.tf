#VPC
resource "aws_vpc" "webserver_vpc" {
  cidr_block = "${var.vpc_cidr}"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Webserver VPC"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "webserver_gateway" {
  vpc_id = "${aws_vpc.webserver_vpc.id}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Webserver Internet Gateway"
  }
}

#Route Tables
resource "aws_route_table" "webserver_public_rt" {
  vpc_id = "${aws_vpc.webserver_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.webserver_gateway.id}"
  }

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Webserver Public RT"
  }
}

#Subnets

#Public Subnets
resource "aws_subnet" "webserver_public_subnet_1" {
  cidr_block = "${var.subnet_cidrs[0]}"
  vpc_id = "${aws_vpc.webserver_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Webserver Public1 Subnet"
  }
}

resource "aws_subnet" "webserver_public_subnet_2" {
  cidr_block = "${var.subnet_cidrs[1]}"
  vpc_id = "${aws_vpc.webserver_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Webserver Public2 Subnet"
  }
}

#RT Associations
resource "aws_route_table_association" "public1_assoc" {
  subnet_id = "${aws_subnet.webserver_public_subnet_1.id}"
  route_table_id = "${aws_route_table.webserver_public_rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id = "${aws_subnet.webserver_public_subnet_2.id}"
  route_table_id = "${aws_route_table.webserver_public_rt.id}"
}