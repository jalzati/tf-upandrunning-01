#! /bin/bash
touch /tmp/foo.txt
echo "Jorge was here!!!" > /tmp/foo.txt
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<center><h1>Deployed via Terraform</h1><center><hr><br><center><i>Powered by Terraform</i></center>" | sudo tee /var/www/html/index.html
