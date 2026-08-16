Context
1.	Creating Infrastructure using Iac tool (Infrastructure as code)
2.	Orchestrating the containers of microservices using Container Orchestartion platform
3.	Following Continuous Integration (CI) to push frequent code changes through a robust secure pipeline
4.	Following Continuous Delivery (CD) and GitOps principles through GitOps tools

Decision
1.	Decided to use Terraform for creating infrastructure through terraform modules
2.	Chosen EKS (Elastic Kubernetes Service) as the container orchestration platform
3.	For Continuous Integration (CI) felt Jenkins would be the better option
4.	The best CD and Gitops tool which perfectly aligns with this project is ArgoCD

Alternatives considered
1.	Chosen Terraform over AWS managed Cloud Formation Template (CFT) because terraform is an open source tool and easy to manage and the terraform modules will reusable. In future if we want to migrate our infrastructure to any other cloud service than AWS then Terraform plays a key role as it supports all the cloud providers whereas CFT supports only AWS.
2.	EKS was decided instead of ECS because EKS is an open source Kubernetes tool and it can be run anywhere where Kubernetes runs but ECS is only sticked to AWS.
3.	Jenkins and ArgoCD were chosen for CI/CD pipeline instead of AWS Code pipeline and code deploy because they have extra features which AWS services won’t support and they are easily manageable and tracable.

Consequences
1.	By choosing external open-source tools we need to manage them without continuous support
2.	We need to build the things from scratch whereas AWS provides built-in templates for some tasks.

