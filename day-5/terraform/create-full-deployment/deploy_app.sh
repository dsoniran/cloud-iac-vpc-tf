#!/bin/bash

# update packages
sudo apt update -y

# upgrade packages
sudo apt upgrade -y

# install git if it's not there
sudo apt install git -y

# get the app code
git clone https://${github_token}@github.com/LSF970/nodejs2-sparta-test-app-2025.git

# install nginx
sudo apt install nginx -y

# install sed
sudo apt install sed -y

# use sed to change nginx config - replace a required line
sudo sed -i '51c\proxy_pass http://127.0.0.1:3000;' /etc/nginx/sites-available/default

# restart nginx
sudo systemctl restart nginx

# enable --> makes the process a startup process
sudo systemctl enable nginx

# install curl
sudo apt install curl -y

# download required version of nodejs (20.x)
sudo bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -"

# install nodejs 20
sudo apt install nodejs -y

# cd into repo and app folder
cd nodejs2-sparta-test-app-2025/app

# set up the app - install dependencies
sudo npm install

# install pm2 --> process manager for node apps
sudo npm install pm2 -g

# kill all running node processes
pm2 kill

# start the app with pm2
# alternative to `npm start app.js`
pm2 start app.js