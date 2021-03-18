#!/bin/bash
sudo apt-get -y update
sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start

rm -rf /etc/nginx/sites-enabled/default || true
rm -rf /etc/nginx/sites-enabled/flugel || true

sudo cat << EOF >/etc/nginx/sites-enabled/flugel
# Define Pool of servers to load balance
upstream webservers {
    server ${aws_web_1}  weight=1 max_fails=3 fail_timeout=30s;
    server ${aws_web_2}  weight=2 max_fails=3 fail_timeout=30s;
}

# Forward traffic on port 80 to one of the servers in the webservers group
server {
    listen 80;
    location / {
            proxy_pass http://webservers;
    }
}
EOF

sudo sed -i 's/#server_name_in_redirect off;/server_name_in_redirect off;/' /etc/nginx/nginx.conf

sudo mkdir /opt/instance1
sudo mkdir /opt/instance2

sudo cat << EOF >/opt/script_nginx.py
import sys
number_instance = sys.argv[1]
tags_name = sys.argv[2]
tags_owner = sys.argv[3]
tags_description = sys.argv[4]
with open("/opt/instance"+ str(number_instance) +"/index.html", "w") as f:
    f.write("Tag Name: " + tags_name + "\n")
    f.write("Tag Owner: " + tags_owner + "\n")
    f.write("Tag Description: " + tags_description + "\n")
EOF

sudo python3 /opt/script_nginx.py 1 "${aws_web_1_tags_name}" "${aws_web_1_tags_owner}" "${aws_web_1_tags_description}"
sudo python3 /opt/script_nginx.py 2 "${aws_web_2_tags_name}" "${aws_web_2_tags_owner}" "${aws_web_2_tags_description}"

sudo chmod 400 /home/ubuntu/${ssh_key_name}.pem

sudo scp -i "/home/ubuntu/${ssh_key_name}.pem" -o StrictHostKeyChecking=no -v /opt/instance1/index.html "ubuntu"@"${aws_web_1}":"/tmp/index.html" 2> /tmp/scp_1_error.log
sudo scp -i "/home/ubuntu/${ssh_key_name}.pem" -o StrictHostKeyChecking=no -v /opt/instance2/index.html "ubuntu"@"${aws_web_2}":"/tmp/index.html" 2> /tmp/scp_2_error.log

sudo service nginx restart