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
    description = "Allow outbound traffic"
  }

  tags {
    Name = "Web Server Security Group"
    Owner = "jalzati@anomali.com"
    Department = "DevOps"
    Environment = "research"
  }
}

#resource "aws_eip" "dev_elasticip" {
#  vpc = true
#  count = "${var.nwebservers}"
#  instance = "${element(aws_instance.webserver.*.id,count.index)}"

#  tags {
#    Name = "webserver-${count.index}"
#    Owner = "${var.owner}"
#    Department = "${var.department}"
#    Environment = "${var.environment}"
#  }
#}

resource "aws_key_pair" "webserver_keypair" {
  key_name   = "${var.keyname}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "webserver" {

  ami = "${var.ami}"
  instance_type = "${var.ec2type}"
  vpc_security_group_ids = ["${aws_security_group.sg-webserver.id}"]
  count = "${var.nwebservers}"
  key_name = "${var.keyname}"
  subnet_id = "${aws_subnet.webserver_public_subnet_1.id}"

    tags {
      Name = "webserver-${count.index}"
      Owner = "jalzati@anomali.com"
      Department = "DevOps"
      Environment = "research"
    }
  
#user_data =<<EOF
##! /bin/bash
#sudo apt-get update
#sudo apt-get install -y apache2
#sudo systemctl start apache2
#sudo systemctl enable apache2
#echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
#EOF

}
