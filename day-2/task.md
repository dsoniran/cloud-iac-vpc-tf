# Day 2 - Tasks

# Agenda
* Understand VPCs and how they work
* Get deployment of app and db working inside VPC
* Document VPC accordingly
    * What are they?
    * Why implement one?
    * What are CIDR Blocks?
    * Our VPC Diagram?
    * Step by step guide?
* Redo VPC deployment using notes/documentation
* **Bonus**: Can you deploy and ASG in your VPC?!?
* **Bonus**: Try to implement a nginx reverse proxy manually
Make an image (AMI if successful)

## Research IaC and Terraform
    1. What is IaC?
    2. What are the benefits?
    3. Who is using it?
    4. Orchestration vs Config Management?
    5. What is Terraform?
    6. How does it work?
## Install TF locally
    * Install documentation: https://developer.hashicorp.com/terraform/install
    * Guide to install on Windows: https://dev.to/annysah/step-by-step-guide-to-installing-terraform-on-windows-m2e

## Document the installation process
Manual installation on MacOS:


1. Download the macOS binary from [HashiCorp's Terraform downloads page](https://developer.hashicorp.com/terraform/install).

2. Unzip the file and move the `terraform binary` to `/usr/local/bin`:
    ```
    sudo mv terraform /usr/local/bin/
    ```

3. Verify installation:
    ```
    terraform -version
    ```
