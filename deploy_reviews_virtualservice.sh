#!/bin/bash
source ./export_constants.sh

#export NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$(kubectl config current-context)\")].context.namespace}")
#echo $NAMESPACE
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
kubectl config set-context --current --namespace=$NAMESPACE
kubectl apply -f $ISTIO_HOME/samples/bookinfo/networking/destination-rule-all.yaml
kubectl apply -f $PWD/admin/virtual-service-reviews-60-20-20.yaml
