# Refresher of App Deploymet

Description of key-pair
Descripton of IP address
Description of DNC (domain name)
Description of a port - generally 80 for http

Description of proxy
Normal proxy, sits on user side, can change the ip address of the server. ie. a vpn. protects the user.

image
user>proxy>server

description of reverse proxy
user < reverse proxy > server

reverse proxy on port 3000 to show what is going on port 80.



--
Monolith deployment
---
|app|db|
---

Two tiered deployment
app+db
the defort port for mongo db is 27017 instance

allows the app to connect to the database. once the connection is successful. put pull data 
app, makes a collection, random data inserted to the mongodb.
then the post page pulls the data to insert into ip-address/post to show for the user.
google which is seeding

---
step 1
manually - the single commands (sudo install, etc.)

step 2
script, automates something for you. single file
can be bash, psh, python, etc.
do all actions in a single command.

step 3
custom image (aws is ami)
template for script. saved file.

step 4
AMI + user data
simple script that will run when the instance is launched.
so the insertion of the mongodb ip address for the connection.

Step 5
autoscaling and load balancers

Step 6
Still needed to manually deploy the mongodb instance for the connection.
Next step is the terraform to deploy both.

nb. sudo > super user do
ssh - secure shell
scp - secure copy

suggestion to not use scp > consider using git clone https.../.git
Can store the sparta app on github.