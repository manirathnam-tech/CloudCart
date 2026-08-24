                                      CIDR ALLOCATION

We need one non-overlapping /20 CIDR (4,096 addresses) per environment: Dev/Stage/Prod

Dev Environment:
CIDR - 10.55.0.0/20
 

Staging Environment:
CIDR - 10.56.0.0/20
 

Prod Environment:
CIDR - 10.57.0.0/20
 

We need 3 Availability Zones for each environment and in each AZ we need one public, one private and one data subnet.

Dev Environment

Subnet	   AZ1	          AZ2	        AZ3
Public	10.55.0.0/24	10.55.1.0/24	10.55.2.0/24
Private	10.55.4.0/24	10.55.5.0/24	10.55.6.0/24
Data	10.55.8.0/24	10.55.9.0/24	10.55.10.0/24

Staging Environment

Subnet	  AZ1	            AZ2	          AZ3
Public	10.56.0.0/24	10.56.1.0/24	10.56.2.0/24
Private	10.56.4.0/24	10.56.5.0/24	10.56.6.0/24
Data	10.56.8.0/24	10.56.9.0/24	10.56.10.0/24

Prod Environment

Subnet	    AZ1	          AZ2          	AZ3
Public	10.57.0.0/24	10.57.1.0/24	10.57.2.0/24
Private	10.57.4.0/24	10.57.5.0/24	10.57.6.0/24
Data	10.57.8.0/24	10.57.9.0/24	10.57.10.0/24








