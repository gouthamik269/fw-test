# AWS Multi-Tier Infrastructure with Terraform

## Project Overview

This repository provides Terraform configuration files to deploy a highly available and secure AWS infrastructure environment following best practices for network segregation, service connectivity, and fault tolerance.

The architecture consists of two separate Virtual Private Clouds (VPCs):

- **EKS VPC**: Hosts the private, highly available Amazon Elastic Kubernetes Service (EKS) cluster and associated resources. The VPC is configured with six subnets (three public and three private) across three availability zones for redundancy and fault tolerance. NAT Gateways and Elastic IPs are provisioned in the public subnets to allow controlled outbound internet access from the private subnets hosting the EKS worker nodes.
- **RDS VPC**: Dedicated to Amazon RDS (PostgreSQL) resources, designed for data persistence and enhanced security. This VPC is also segmented across three private subnets in different availability zones.

A VPC peering connection is established between the EKS VPC and RDS VPC to enable secure and low-latency communication between application workloads running in EKS and the managed PostgreSQL database in RDS. Security groups are carefully configured to permit only necessary traffic between EKS nodes and RDS instances.

Other key components include:

- **Amazon S3 Bucket**: Provisioned for object storage, with an S3 Gateway VPC endpoint configured to ensure private, secure, and high-performance connectivity from EKS and other private resources to S3, without traversing the public internet.
- **IAM Roles and Policies**: Managed using dedicated Terraform modules to ensure the principle of least privilege and secure access between AWS services.
- **Modular Terraform Design**: The solution utilizes reusable Terraform modules for VPC, EKS, RDS, S3, and IAM. All modules are instantiated and orchestrated from the root `main.tf` file. For simplicity and maintainability, the code leverages a baseline approach rather than advanced looping constructs like `for_each`.
- **EKS Node Group AMI**: The EKS worker nodes leverage the AWS SSM Parameter Store to retrieve and use the latest recommended AMI image, aligning with AWS best practices for node security and stability.
- **Fault Tolerance**: The infrastructure is designed with multi-AZ redundancy at every layer, including subnets, RDS, and EKS worker nodes, to ensure high availability and resilience to failure.
- **Security**: All inter-service communication is tightly controlled through well-defined security groups, VPC routing, and endpoint policies. No resources require public internet exposure except those explicitly intended (e.g., NAT Gateways in public subnets).


## Java Application Helm Chart & GitOps Deployment
This repository includes a custom Helm chart and supporting GitOps configuration for deploying a scalable Java application on Kubernetes, following modern cloud-native best practices.

**Custom Helm Chart**:
The Java application is packaged as a Helm chart (java-app), created using the standard helm create workflow. The chart defines application deployments, Kubernetes Services, resource management, and scaling policies. You can find the chart and all configuration files in the helm_charts directory.

**GitOps Automation with Argo CD**:
Deployment and lifecycle management are fully automated via Argo CD. Application manifests for Argo CD are located in the argo-applications directory. When changes are committed to the repository, Argo CD automatically synchronizes the Kubernetes cluster to the latest desired state, ensuring continuous delivery with minimal manual intervention.

**Ingress & Load Balancing**:
Traffic to the Java application is routed through an NGINX Ingress Controller. The application's Kubernetes Service is configured as type: LoadBalancer, which provisions an internal AWS Network Load Balancer. All external and internal traffic flows through this load balancer, providing secure and scalable ingress for the application.

**Scaling & Resources**:
The Helm chart supports configurable scaling through the replicaCount parameter, allowing you to specify the desired number of application pods. Resource requests and limits (CPU and memory) are also defined in values.yaml to ensure predictable scheduling and performance.

