#!/bin/bash
source ./export_constants.sh

gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

kubectl config set-context --current --namespace=$NAMESPACE

kubectl delete -f $ISTIO_HOME/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl delete -f $ISTIO_HOME/samples/bookinfo/networking/destination-rule-all.yaml
kubectl delete -f $PWD/admin/virtual-service-reviews-60-20-20.yaml
kubectl delete -f $ISTIO_HOME/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl config set-context --current --namespace=default
kubectl label namespace $NAMESPACE istio-injection-
kubectl delete -f $PWD/admin/namespace-bookinfoapp.json
