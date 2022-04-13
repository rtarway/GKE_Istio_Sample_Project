# MonetaGo_Assignment
MonetaGo Assignment Private Repo

# Cloud Engineer:Google - Technical Assignment - Solution

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

## Overall Prerequisite for solution

1. Terraform should be installed.
2. gcloud sdk should be installed.
3. kubectl should be installed.
4. git command line should be installed.
5. `gcloud auth login` should be run before running any terraform or shell script. 

###
## Solution for Specification 1
I have used examples and modules from "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster" to create private cluster. 
- I have modified examples\gke-private-cluster\main.tf to add "shielded node config" 
- I have modified modules\gke-cluster\main.tf to add autoscaling for cluster
- I have modified modules\gke-service-account\main.tf to add more permissive project editor role to cluster SA

Instructions for creating GKE cluster

1. Complete prerequisites.
2. Clone repository in your local env. 
3. navigate to terraform_files\examples\gke-private-cluster\
4. validate variables in terraform.tfvars 
5. run `terraform init`
6. run `terraform apply` , enter 'yes' if plan looks ok.

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

Instructions

0. Complete prerequisites and create gke cluster as per solution of specification. Navigate to root directory of repository. 
1. Validate the variables in `./export_constants.sh` 
2. run `./setup_Istio.sh` to download Istio 1.13.2 and install using istioctl with default profile
3. run `./deploy_bookinfo_with_istio_sidecar.sh` to install bookinfo sample application in namespace 'bookinfoapp' with Istio side car injection enabled. You may need to run `kubectl get pods` to validate the status of running pods and avaialabiltiy as 2 pods for each deployment. 
4. run `./deploy_bookinfo_gateway.sh` to deploy a custom ingress gateway. Navigate to gateway URL to visit the application. Kiali dashboard is also enabled by this script. run `istioctl dashboard kiali` in separate terminal to look at dashboard. This script also makes 100 calls to bookinfo application to populate the graph.
5. run `./deploy_reviews_virtualservice.sh` to deploy reviews as a virtual service with subset v1, v2, v3 having a traffic distribution of 60,20,20 respectively. To test the traffic distribution , run `for i in $(seq 1 1000); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done`, with GATEWAY_URL replaced or exported. 
6. Sample traffic distribution in testing  ![image](https://user-images.githubusercontent.com/9452704/163036826-31750ee5-ad23-47a8-96d1-a742e499e94f.png)


## Solution for Clean up

1. run `./cleanup_deployment.sh` to remove bookinfo application and gateway
2. run `./cleanup_istio_from_cluster.sh` to remove all addons and istio from cluster
3. navigate to terraform-file\examples\gke-private-cluster and run `terraform destroy` to delete the cluster.

## Known Issues

1. The master_authorized_networks_config is currently allowed from all ips "0.0.0.0/0" for easier testing. Private cluster should allow only projects vpc to connect to cluster. It can be achieved by creating a vm as bastion host in authorized network
2. Service account for cluster has project editor role, which is too permissive. I kept it for easier testing. It can be improved further to restrict to specific needs.
3. ./setup_Istio.sh installs Istio but does not check status of `curl` or `istioctl install -y`
4. ./deploy_bookinfo_with_istio_sidecar.sh does not check if all pods of bookinfo has sidecar and is in running state before exiting. It simple waits for 10s and prints results of `kubectl get pods`
5. ./deploy_bookinfo_gateway.sh uses a gateway with hosts as *, it can be improved to use a specific hostname.
