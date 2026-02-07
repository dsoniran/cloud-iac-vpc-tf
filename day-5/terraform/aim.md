# Day 4 - Acheivements with Terraform

## 1. Create **Full** Deployment
 * Create a template instance
   * user_data install all necessary libraries and clones [nodejs2-sparta-test-app-2025](https://github.com/LSF970/nodejs2-sparta-test-app-2025)
 * Create an AMI from the above instance
 * Create a launch template using the above AMI
   * user_data exports DB_HOST (using mongodb CIDR block)
 * Create an app instance that functions **independently**.
 * Utilises multi-provider application (GitHub and AWS)

## 2. Create Auto-scaling and Load Balancing
