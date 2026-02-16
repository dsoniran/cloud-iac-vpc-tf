# Getting Started with Terraform

## Interacting with Cloud Providers
There are different ways to interact with cloud providers such as AWS.

## AWS Management Console
* Accessed using **username** and **password**.
* Web-based UI
* Primarily used for manual configuration and visibility.
* Terraform does **not** interact with the console

## Command Line Interface (CLI)
* Used for programmatic access to AWS
* Terraform communicates with AWS via APIs, typically through the **AWS CLI**.

# Access Keys and Shared Credential Management
* Access Keys are used for:
  * Terraform
  * AWS CLI
  * SDKs and automation tools
* The consists of:
  * Access Key ID
  * Secret Access Key
> Terraform requires AWS credentials to authenticate and provision resources.

## How does Terraform authenticate with AWS?
* Terraform uses the same credential mechanism as the AWS CLI
* Credentials are configured locally and securrely (.aws directory)
* Once configured, Terraform can create and manage AWS resources without console access.

# Terraform state file
Resource: [Terraform State](https://developer.hashicorp.com/terraform/language/state)

## What is **Terraform state file**?
**`tfstate`** (Terraform state) is a file that records the current state of the infrastructure as Terraform understands it. It maps the terraform resources in code, and to cloud resources (ids, attributes, dependencies).

By default, it is stored as:
```
terraform.tfstate
```

## Why is `tfstate` important?
* **source of truth**: Terraform uses state to know what exisits.
* **change detection**: It makes comparison with the current state (tfstate), current infratructure (cloud) and desired state (current code).
* It supports **safe updates and deletions**: Prevents Terraform from creating, recreating or destroying the wrong resources.
* **dependency tracking**: Terraform knows what is to be created and in what order

## Why is `tfstate` sensitive?
The state files may contain the follow:
* Resource IDs
* Private IP addresses
* DNS names
* Passwords
* Secrets
* API Keys

## State file best practices
* Always store state remotely (Azure Storage)
* Encrypt rest at rest
* Restrict access via IAM
* Enabled state locking to avoid concurrent changes
> **Best Practice**: **NEVER** commit `tfstate` files to version control. 

* Anyone with the state file may gain infrastructure access.
* Leaked state means leaked credentials
* Manually modifying the state can corrupt environments.

# What is `.terraform.lock.hcl`?
`.terraform.lock.hcl` is Terraform's dependecy lock file.
* Records exact provider versions used by a project
* Ensures consistent, repeatable builds across machines and teams
* Prevents unexpected changes from provider upgrades

> **Best practice**: Commit .terraform.lock.hcl to version control (unlike tfstate).

## Can you find a best practice .gitignore template for terraform projects?

Please see `../.gitignore` for example.
