## Intro to VPCs - Key Takeaways
* VPCs define network boundaries
* CIDR blocks define IP availability
* Route tables define traffic paths
* Security groups define access permissions

Together, these components form the foundation of secure cloud networking.

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


## When cleaning up VPC (i.e. deleting it) see below for recommend order:
1. Remove the VMs in the VPC
2. Remove the security groups associated with the VPC
3. Remove the VPC:
4. When deleting the VPC it should report that it will also delete these 4 resources:
    a. the Internet gateway
    b. the public route table
    c. the private subnet
    d. the public subnet
