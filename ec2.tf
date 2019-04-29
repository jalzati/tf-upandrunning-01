resource "aws_security_group" "sg-webserver" {
  name = "Web Server"
  vpc_id = "${aws_vpc.webserver_vpc.id}"

  ingress {
    from_port = "${var.webserver_port}"
    protocol = "tcp"
    to_port = "${var.webserver_port}"
    cidr_blocks = ["${var.vpnip}"]
    description = "Allow HTTP connections from anywhere in the Internet"
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS connections from only the VPN server"
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${var.vpnip}"]
    description = "Allow SSH connections from only the VPN server"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }

  tags {
    Name = "Web Server Security Group"
    Owner = "jalzati@anomali.com"
    Department = "DevOps"
    Environment = "research"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "webserver_keypair" {
  key_name   = "${var.keyname}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "webserver" {

  ami = "${var.ami}"
  instance_type = "${var.ec2type}"
  vpc_security_group_ids = ["${aws_security_group.sg-webserver.id}"]
  key_name = "${var.keyname}"
  subnet_id = "${aws_subnet.webserver_public_subnet_1.id}"

    tags {
      Name = "Webserver"
      Owner = "jalzati@anomali.com"
      Department = "DevOps"
      Environment = "research"
    }
  
  user_data = "${file("install_apache.sh")}"

}

