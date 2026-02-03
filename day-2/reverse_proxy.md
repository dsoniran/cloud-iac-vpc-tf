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

