# Nginx Reverse Proxy for Sparta app
## What are they?

A Reverse Proxy is simple a piece of software (in our case nginx) that sits in front of a target server and intercepts incoming traffic before it arrives. 

This allows us to work out what we want to do with this traffic, we have more control.

In our case, we will simply get nginx to show what is happening on Port 3000 of our instance (i.e the Sparta test app) without acctually letting the end user access port 80.

This is both more user friendly (no need to add port number to url) and more secure (less ports open to the public).

## Useful articles?

Intro to reverse proxies:
https://www.cloudflare.com/en-gb/learning/cdn/glossary/reverse-proxy/ 

More in depth nginx reverse proxy set up:
https://medium.com/globant/understanding-nginx-as-a-reverse-proxy-564f76e856b2

# Manually configuring the RP
You will need the following as prerequisites:

- Instance with all dependencies needed for Sparta app
- Test Sparta app running

### Follow these steps:

1. SSH into your app instance
2. Run "PM2 kill" in order to stop any running nodejs processes
3. Navigate to the root folder ("cd /")
4. Navigate to the etc folder from here (cd "etc")
Note: etc is where configuration files are stored
5. Find the nginx folder, cd into it
6. Then cd into a folder called "sites-available"
7. In that folder there should be a file called "default", open it with "sudo nano default"
8. Navigate to the location code block
9. Remove the line "try_files..."
10. Add the line "proxy_pass http://127.0.0.1:3000;"
Note: This tells nginx to show what is happening on port 3000 of this instance by default (so on port 80)
11. Save and close the file
12. Navigate back to the app folder
13. Restart nginx so the config change takes effect ("sudo systemctl restart nginx")
14. Start app
15. Check the public IP, where in the past you would see the default nginx page, now you will see the Sparta app

**Bonus**:
See if you can automate this by adding an sed line to your script!

**BonusBonus**: 
Make an AMI that has the reverse proxy setup as well as the app dependencies ready to go

----DS---
# Reverse Proxy

To understanda. reverse proxy, first understand a proxy...

network edge

users > internet > reverse proxy (80=3000) > server (80)
allows the user to see the information on port 3000, but it looks like it is port 80. port 80 mirrors what is on port 3000.

nginx site-avaiable. changed. 
in security group. get rid of the ability for people to access port 3000. so just go to the ip address.

reverse proxy can do load balancing, caching, etc. read cloudflare article.

## Resources
* [Cloudflare - Resverse Proxy](https://www.cloudflare.com/en-gb/learning/cdn/glossary/reverse-proxy/)
* [Medium - Understanding Nginx as a Reverse Proxy](https://medium.com/globant/understanding-nginx-as-a-reverse-proxy-564f76e856b2)

