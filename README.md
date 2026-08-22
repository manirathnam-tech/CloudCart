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

CC - 5
To move the terraform state file from local to backend created an S3 bucket to store state file remotely and achieved state locking through Dynamo DB.
If two engineers try to run terraform apply at the same instant of time this will block the second user and warns him about the first user's wip.
From this we can achieve state locking

