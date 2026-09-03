SECURITY GROUPS — BASELINE (CC-10)

Three tiers, matching the subnet tiers from docs/networking.md. Security groups
attach to resources (ALB, app-tier compute, RDS/Redis), not to subnets directly —
each tier's SG gets attached to whatever resource ends up living in that tier's
subnets as those resources are provisioned in later tickets.

Design rule: only the ALB's two web-facing ports use a CIDR block (0.0.0.0/0).
Every other rule in every other tier references a source security group instead
of an IP range, so access is scoped to "traffic from a specific trusted resource,"
not "traffic from an IP range that happens to usually be trusted." This is what
actually stops a compromised frontend from reaching the database directly, even
if it's sitting inside what looks like the right subnet.

RULES

Security Group | Rule                    | Direction | Port  | Protocol | Source/Destination | Justification
alb_sg          | alb_http                | Ingress   | 80    | TCP      | 0.0.0.0/0           | Allow inbound HTTP from the internet to the ALB
alb_sg          | alb_https               | Ingress   | 443   | TCP      | 0.0.0.0/0           | Allow inbound HTTPS from the internet to the ALB
alb_sg          | alb_to_app              | Egress    | 8080  | TCP      | app_sg              | Allow ALB to forward requests to the app tier
app_sg          | app_from_alb            | Ingress   | 8080  | TCP      | alb_sg              | Allow inbound traffic from the ALB only
app_sg          | app_to_postgres         | Egress    | 5432  | TCP      | data_sg             | Allow app tier to reach RDS Postgres
app_sg          | app_to_redis            | Egress    | 6379  | TCP      | data_sg             | Allow app tier to reach ElastiCache Redis
data_sg         | data_postgres_from_app  | Ingress   | 5432  | TCP      | app_sg              | Allow RDS Postgres access from app tier only
data_sg         | data_redis_from_app     | Ingress   | 6379  | TCP      | app_sg              | Allow ElastiCache Redis access from app tier only

Port 8080 is a placeholder (var.app_port default) until the actual application's
listening port is confirmed when the compute layer is built.

KNOWN GAP

app_sg currently has no egress beyond the two data-tier rules above. Once real
services are deployed, they'll need additional scoped egress rules to reach AWS
service endpoints (Secrets Manager, DynamoDB, SQS/SNS) and any third-party APIs —
tracked as follow-up work, not opened as 0.0.0.0/0 by default when it comes up.
