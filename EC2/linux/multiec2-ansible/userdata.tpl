#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo touch /var/www/html/index.html
sudo echo "Hello World this is unit " > /var/www/html/index.html
sudo hostname >> /var/www/html/index.html
sudo chown -R apache:apache /var/www/html/*
sudo systemctl start httpd
sudo systemctl enable httpd