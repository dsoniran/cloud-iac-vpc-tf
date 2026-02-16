# Refresher of App Deploymet (12-Feb-26)

## Core Concepts
### Key-Pair
Used for secure SSH access to EC2 instances (public/private key authentication)
### IP Address
A unique identifier for a machine on a network (private inside VPC, public for internet access).
### Domain Name System (DNS)
Translates human-readable domain names into IP addresses.
### Port
Defines which service is accessed on a machine.
    * `80` -> HTTP
    * `443` -> HTTPS
    * `27017` -> MongoDB (default)

## Proxy v. Reverse Proxy
### Proxy (Forward Proxy)
* Sits on the **user side**
* Masks the user's IP address; protects the user
* Common example: VPN
```
User -> Proxy -> Server
```

## Reverse Proxy
* Sits on the **server side**
* Masks the backend servers from users
* Routes traffic to internal services
* Example use case:
  * Public traffic on port 80
  * Forwarded internally to port 3000
```
User <- Resverse Proxy -> Server
```

## Deplomynet Models
### Monolith Architecture
* Aplication and database run together
* Simple but not scalable
```
| App + DB |
```

## Two-Tier Architecture
* App and database run on separate instances
* App connects to database, creates random collections, seeds data (inserts data to database), and serves it via `/post` IP extension.
```
App -> DB
```

## Deployment Evolution
### Step 1 - Manual Setup
* Run individual commands (`sudo install`, etc.)

### Step 2 - Scripts
* Automate setup using a single script. i.e. bash, ps1, python
* //delete// All actions completed in a single command

### Step 3 - Custom Image (AMI)
* Pre-baked machine image

### Step 4 - AMI + User Data
* Simple script that will run when the instance is launched
* Used to inject configurations (e.g. MongoDB private IP)

### Step 5 - Auto Scaling + Load Balancers
* App tier scales automatically
* Load balancers distributes traffic (review recording :/)

### Step 6 -  Infrastructure as Code (IaC)
* **Next Step for this Sprint**: Terraform to deploy both app and db.

## Refresher Commands
* `sudo` -> 'Super User DO'
* `ssh` -> Secure Shell
* `scp` -> Secure CoPy
> **Best Practice**: Avoid `scp` for app code. Use `git clone https://.../.git` from a Git repository (i.e. GitHub) instead. NB. Store sparta app on GitHub.
