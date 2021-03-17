#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install nginx
sudo apt-get -y install python3
sudo service nginx start

sudo rm -rf /opt/script_nginx.py || true
sudo rm -rf /var/www/html/index.html || true

sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html/index.html

sudo chown ubuntu:root /var/www/html/*
sudo chmod 777 /var/www/html/*
sudo chown ubuntu:root -R /var/www/html/
sudo chmod 777 -R /var/www/html/

sudo mv /tmp/index.html /var/www/html/index.html

sudo service nginx restart