# Day 1 - Task

1. Work out what is wrong with your app and db deployment (inside your VPC)

    * Check SG rules
    * Check DB_HOST connection string
    * Check VPC settings again

2. Remake the VPC again, document in depth this time (Screenshots and step by step guidance). Steps below (at a glance)

    * Make VPC (10.0.0.0/16)
    * Make Subnets (10.0.2.0/24 and 10.0.3.0/24)
    * Create IG and attach to VPC
    * Create Public RT
      - Associate with public subnet
      - Add route to the internet via IG  (0.0.0.0/0)
    * Check setup
    * Try to deploy app and db

3. Try to automate app and db deployment in your VPC by using your own images and user data 
