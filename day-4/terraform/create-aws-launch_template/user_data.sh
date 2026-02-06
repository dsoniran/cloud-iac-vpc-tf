# enter directory with application script
cd nodejs2-sparta-test-app-2025/app

# install npm
sudo npm install --yes

# fetch MongoDB instance private IP dynamically using AWS CLI
# export MongoDB_IP=$(aws ec2 describe-instances \
#   --filters "Name=tag:Name,Values=MongoDB" "Name=instance-state-name,Values=running" \
#   --query "Reservations[0].Instances[0].PrivateIpAddress" \
#   --output text)
# export DB_HOST="mongodb://${MongoDB_IP}:27017/posts"

export DB_HOST="mongodb://${aws_instance.ec2_mongodb_instance.private_ip}:27017/posts"

# kill any active operations
pm2 kill

# seed the data
node seeds/seed.js

# start app
pm2 start app.js