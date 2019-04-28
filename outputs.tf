output "public_ip" {
  value = "${aws_instance.webserver.0.public_ip}"
}