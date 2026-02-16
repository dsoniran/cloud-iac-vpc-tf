# Introduction to IaC & Terraform
Terraform : Shape the landscape (the earth)

## What is Infrastructure as Code (IaC)?
Infrastructure as Code (IaC) is a practice of managing and provisioning infrstructure using code rather than manual processes.

Instead of utiilising the cloud console, infrastructure is:
* Defined in configuration files
* Version-controlled
* Repoducible
* Automated

## Orchastration vs Configuration Management

### Orachastrations (Declarative)
* Focusses on provisioning and manageing infrsstructure
* Creates resources such as storage accounts, VMs, Networks, etc.
* Example Tools: Terraform

### Configuration Management (Imperitive)
* Focusses on configuring softare inside servers.
* Manages packages, services and OS settings
* Example Tools: Ansible, Puppet, Bash Scripts

> *Terraform builds the house, Ansible furtnishes it.*

```
Declarative vs Imperative (Important Concept)

* Declarative (Terraform):
“This is what I want the infrastructure to look like.”

* Imperative (scripts):
“Run these steps in this order.”

Terraform determines how to reach the desired state.
```

## Benefits of IaC
* **Consistency**: Same infrstructure each time, no manual drift.
* **Automation and Speed**: Environments can be provisioned and destroyed easily.
* **Version Controlled**: Infrastructure changes can be reviewed, tracked and rolled back.
* **Scalability**: Easily replicable across environments.
* **Reduced human error**: Eliminates misconfigurations caused by manual setup.
* **Disaster recovery**: Infrasrtucture can be recreated from code.

## Who uses IaC?
* DevOps Engineers
* Site Reliability Engineers (SREs)
* Cloud Engineers
* Platform teams

## What is Terraform?
Terrform is an open-source IaC orchastration tool created by HashiCorp.

It allow you to define infrastructure in declarative configuration files. Provisions resources across:
* AWS
* Azur
* GCP
* Kubernetes
* GitHub

### Additional Benefits with Terraform (IaC)
* **Standardisation of infrastructure** especially across team and large organisations.
* **Collaborative**: State file management enables fast changes to complex insfratutcture with version control and state locks.
* **Modular and declaritive**: Tells the tool what we want. If already there, only creates and destroy necesssary item. Facilitates complex architectures as we can codify. 
* **Visibility**: Easy linting, formatting and validation of code. `terraform plan` also enables views of changes before confirmation.

## How Terraform Works
1. **Write**: Infrastructure is defined `.tf` files using HCL. You can find the provider information on the Hashicorp website that details the resource configuration.
2. **Initialisation**: Terraform downloads the required providers:
    ```bash
    terraform init
    ```
3. **Plan**: Terrform calculates the changes:
   ```bash
   terraform plan
   ```
4. **Apply**: Terraform creates or updates inrastructure:
    ```bash
    terraform apply
    ```
5. **State Management**: Terraform maintains a **state files**, which tracks the infrastructure in comparision to the code. This enables safe updates and deletions.

## How to Check if Terraform in Installed Locally
Run the following comman:
```bash
terraform --version
```
Expected Output: Display the Terraform version is present; error if not.
