#!/bin/bash
export GKE_CLUSTER_NAME=monetgo-private-cluster
export PROJECT_ID=my-kubernetes-codelab-345416
export ZONE=us-central1-c
export REGION=us-central1
#export KEY_FILE_PATH=$HOME/my-kubernetes-codelab-345416-f04ccc5a7d86.json
cd $HOME
#download istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.13.2 TARGET_ARCH=x86_64 sh -
export ISTIO_HOME=$HOME/istio-1.13.2
export PATH=$ISTIO_HOME/bin:$PATH
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
istioctl install -y
istioctl verify-install
