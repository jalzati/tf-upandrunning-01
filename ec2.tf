resource "aws_security_group" "sg-webserver" {
  name = "Web Server"

  ingress {
    from_port = "${var.webserver_port}"
    protocol = "tcp"
    to_port = "${var.webserver_port}}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Web Server Security Group"
    Owner = "jalzati@anomali.com"
    Department = "DevOps"
    Environment = "research"
    ServerPort = "${var.webserver_port}}"
  }
}

resource "aws_instance" "webserver" {

  ami = "ami-03d12de7d0e87fbf3"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg-webserver.id}"]
  count = 2

    tags {
      Name = "webserver-${count.index}"
      Owner = "jalzati@anomali.com"
      Department = "DevOps"
      Environment = "research"
    }

    user_data = <<-EOF
      #!/bin/bash
      echo "<html><head><title>EHLO</title></head><body><center><h2>Hello World!!!</h2><center><hr><center>Powered by Terraform</center></body></html>" > index.html
      nohup busybox httpd -f -p 8080 &
    EOF
  }