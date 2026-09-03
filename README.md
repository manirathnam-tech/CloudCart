# CloudCart
My Cloud & DevOps Project

CC - 1
Created an AWS account and enabled MFA for root user and root keys access does not exist
An IAM admin user is created
3 Billing alarms were created for $10, $20, $30 respectively and notified through SNS

CC - 2
Created an Architecture Decision Record (ADR) file under /docs/adr folder and named it as 0001-tech-stack.md (docs/adr/0001-tech-stack.md)

CC - 3
–	Created repo skeleton folders
–	Written CONTRIBUTING.md with branching + commit rules
–	Enabled branch protection rule on main (require PR)

CC - 4
Documented, version-pinned local toolchain

CC - 6
To move the terraform state file from local to backend created an S3 bucket to store state file remotely and achieved state locking through Dynamo DB.
If two engineers try to run terraform apply at the same instant of time this will block the second user and warns him about the first user's wip.
From this we can achieve state locking
Technical steps:
1. Provisioned an S3 bucket which versioning + encryption enabled and blocks public access
2. Created a DynamoDB table with LockID as the key for state locking
3. After this backend.tf file was created to tell terraform to move state file from local to remote


CC - 7
Added networking documentation for environments in docs/networking.md

CC - 8
Created terraform module for provisioning a Virtual Private Cloud (VPC), an Internet Gateway, Public/Private/Data subnets across 3 Availability zones

CC - 9
1. Cretaed Terraform module for provisioning NAT gateway and route tables and their particular associations
2. Created routes to associate public subnet to IGW and private subnet to NAT gateway

CC - 10
1. Created a security-groups Terraform module defining tiered baseline security groups (ALB, app, data tier) with least-privilege rules
2. App-tier and data-tier ingress reference source security groups (SG-to-SG) instead of hardcoded CIDR blocks

