# MonetaGo_Assignment
MonetaGo Assignment Private Repo

# Cloud Engineer::Google - Technical Assignment - Solution

## Table of Contents
1. Objective
2. Specifications
3. Allowed Materials

## Objective
Create a Google Kubernetes Engine(GKE) cluster + service mesh using allowed materials. Develop the code resources in a structured and organized way, ensuring best practice with style and DRY principals. The code should be committed to your own private Git repository and then subsequently shared with MonetaGo engineers when requested.

## Specifications

## Specification 1: The GKE cluster should have the following properties and application services:

* Private cluster
    * Remove default node pool
    * Control plane authorized networks
    * Custom node pool
        * Autoscaling
    * Shielded nodes

## Solution for Specification 1
I have used examples and modules from "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster" to create private cluster. 
- I have modified examples\gke-private-cluster\main.tf to add "shielded node config" 
- I have modified modules\gke-cluster\main.tf to add autoscaling for cluster
- I have modified modules\gke-service-account\main.tf to add more permissive project editor role to cluster SA

Instructions for creating cluster

Inside terraform_files, 
1. navigate to examples\gke-private-cluster\
2. validate variables in terraform.tfvars 
3. run terraform init;
4. run terraform apply , enter 'yes' if plan looks ok.

Known issues
1. The master_authorized_networks_config is currently allowed from all ips "0.0.0.0/0" for easier testing. Private cluster should allow only projects vpc to connect to cluster. It can be achieved by creating a vm as bastio host in authorized network

2. Service account for cluster has project editor role, which is too permissive. I kept it for easier testing. It can be improved further to restrict to specific needs.



## Specification 2
* Istio service mesh
    * Default or minimal profile
    * Ingress Gateway
    * Gateway
    * Virtual Service
    * Custom app namespace
* Namespaces with Istio Sidecar Proxy
* App deployment into custom app namespace

## Solution for specification 2

After creating cluster
 
1. run ./SetUpIstio.sh to download Istion 1.13.2 and install using istioctl with default profile
2. run ./deployBookInfoWithIstioSideCar.sh to install bookinfo sample application in namespace 'bookinfoapp' with Istio side car injection enabled
3. run ./deployIstioGatewayForBookInfo.sh to deploy a custom ingress gateway; Navigate to gateway URL to visit the application. Kiali dashboard is also enabled by this script. 

Cleanup
1. ./cleanUpDeployment.sh removes bookinfo application and gateway
2. ./cleanUpIstioFromCluster.sh removes all addons and istio from cluster
3. navigate to terraform-file\examples\gke-private-cluster and run terraform destroy to delete the cluster.

known issues


## Allowed Materials
* Google Cloud project
* Google Kubernetes Engine
* Google Cloud SDK
* Shell scripting
* Pulumi
* Terraform
* Any public app deployment (such as httpbin or nginx) can deployed into the custom namespace

**Time:** The assignment should be completed and submitted within 1 week of receiving access to this assignment.

Feel free to contact MonetaGo with any questions. Good luck!
