#!/bin/bash

# enter directory with application script
cd nodejs2-sparta-test-app-2025/app

# install npm
sudo npm install --yes

# export database private ip address
# export DB_HOST="$(terraform output -raw db_host)"
export DB_HOST=${db_host}
# echo "DB_HOST=${db_host}" >> etc/environment

# kill any active operations
pm2 kill

# seed the data
node seeds/seed.js

# start app
pm2 start app.js