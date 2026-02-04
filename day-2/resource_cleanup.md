# When cleaning up VPC (i.e. deleting it) see below for recommend order:
1. Remove the VMs in the VPC
2. Remove the security groups associated with the VPC
3. Remove the VPC:
4. When deleting the VPC it should report that it will also delete these 4 resources:
    a. the Internet gateway
    b. the public route table
    c. the private subnet
    d. the public subnet

## Intro to VPCs - Key Takeaways
* VPCs define network boundaries
* CIDR blocks define IP availability
* Route tables define traffic paths
* Security groups define access permissions

Together, these components form the foundation of secure cloud networking.
