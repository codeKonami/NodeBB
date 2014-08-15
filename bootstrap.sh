#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y nginx
sudo apt-get install -y git
sudo apt-get install -y imagemagick
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-get update
sudo apt-get install -y redis-server

echo 'server {
    listen 80;

    server_name nodebb.dev;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:4567/;
        proxy_redirect off;

        # Socket.IO Support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}' > /etc/nginx/sites-available/app
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app

sed -i 's/sendfile on;/sendfile off;/g' /etc/nginx/nginx.conf
useradd app
mkdir /home/app
ln -fs /vagrant /home/app/public_html
mkdir /home/app/logs
touch /home/app/logs/error.log
touch /home/app/logs/access.log

service nginx start

cd /home/app/public_html
sudo npm install