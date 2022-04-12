#!/bin/bash
export GKE_CLUSTER_NAME=monetgo-private-cluster
export PROJECT_ID=my-kubernetes-codelab-345416
export ZONE=us-central1-c
export REGION=us-central1
export ISTIO_HOME=$HOME/istio-1.13.2
export PATH=$ISTIO_HOME/bin:$PATH
export NAMESPACE=bookinfoapp

#export NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$(kubectl config current-context)\")].context.namespace}")
#echo $NAMESPACE

kubectl config set-context --current --namespace=$NAMESPACE
kubectl apply -f $ISTIO_HOME/samples/bookinfo/networking/destination-rule-all.yaml
kubectl apply -f $PWD/admin/virtual-service-reviews-60-20-20.yaml
