#!/bin/bash
export GKE_CLUSTER_NAME=monetgo-private-cluster
export PROJECT_ID=my-kubernetes-codelab-345416
export ZONE=us-central1-c
export REGION=us-central1
export ISTIO_HOME=$HOME/istio-1.13.2
export PATH=$ISTIO_HOME/bin:$PATH
export NAMESPACE=bookinfoapp

gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

kubectl config set-context --current --namespace=$NAMESPACE

kubectl delete -f $ISTIO_HOME/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl delete -f $ISTIO_HOME/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl config set-context --current --namespace=default
kubectl label namespace $NAMESPACE istio-injection-
kubectl delete -f $HOME/admin/namespace-bookinfoapp.json