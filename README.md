# eks
This repo contains terraform files which would create the following AWS resources.
1. a AWS VPC with two private subnets and two public subnets
2. launches an eks cluster in private subnets, creates an eks managed node with 2 t3.micro spot instaces in the private subnets
3. a NAT instance is created in one of the public subnets and a route is created to it from the private subnets 
4. IAM users and roles and maps them to the default cluster role
5. Installs POD Identity Add-on
6. Initialize helm provider and installs Metrics Server and Cluster Auto Scaler
7. Installs AWS Load Balancer controller for creating External load balancers in public subnets and the required IAM role resources 
8. Nginx Ingress controller and along with it an external load balancer
9. Installs Cert Manager for automated management of certs required for configuring Ingress resources with TLS and the required roles 
10. Installs EKS EBS CSI Driver and the required roles 
11. Installs EKS EFS CSI Driver and the required roles 


## Prerequisites

Before running the script, make sure you have:

-   An AWS account with appropriate permissions with admin privileges to bootstrap the eks cluster.
-   AWS CLI installed and configured with your the above AWS account keys
-   An SSH key pair created in the AWS region where you intend to launch the instances(optional).
-   Terraform installed

## Usage

1.  Clone the repository to your local machine:
    `git clone https://github.com/gmanikantareddy/eks.git`
2.  Navigate to the cloned directory:
    `cd eks` 
3.  Update the `locals.tf` file with your desired configuration. You need to specify the AWS region, and nodes, others are optional
4.  Run the Terraform script:

        terraform init
        terraform plan
        terraform apply 
        
5.  Wait for the script to complete. Once finished, you'll have a fully functional aws eks cluster ready for use.