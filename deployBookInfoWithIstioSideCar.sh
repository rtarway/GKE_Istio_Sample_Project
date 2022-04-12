#!/bin/bash
export GKE_CLUSTER_NAME=monetgo-private-cluster
export PROJECT_ID=my-kubernetes-codelab-345416
export ZONE=us-central1-c
export REGION=us-central1
export ISTIO_HOME=$HOME/istio-1.13.2
export PATH=$ISTIO_HOME/bin:$PATH

#setup gcloud
#gcloud auth activate-service-account --key-file $KEY_FILE_PATH
#cd $ISTIO_HOME
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

#create namespace for application
kubectl create -f $HOME/admin/namespace-bookinfoapp.json
#enable namespace for side car injection
kubectl label namespace bookinfoapp istio-injection=enabled

#Switch context to new namespace
#kubens bookinfoapp
kubectl config set-context --current --namespace=bookinfoapp

#add a script to modify the firewall rule to open port 15017 for gke master ingress.
export firewall_rule_name=`gcloud compute firewall-rules list --filter="name~gke-$GKE_CLUSTER_NAME-[0-9a-z]*-master" --format=json|jq -r '.[0].name'`
gcloud compute firewall-rules update ${firewall_rule_name} --allow tcp:10250,tcp:443,tcp:15017

kubectl apply -f $ISTIO_HOME/samples/bookinfo/platform/kube/bookinfo.yaml
echo `kubectl get services`
echo `kubectl get pods`
sleep 10
echo `kubectl get pods`
echo 'checking bookinfo application deployed'
title=`kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"`
echo $title

if [ "$title"="<title>Simple Bookstore App</title>" ] ; then
    echo "BookInfo application is successfully deployed with istio in custom namespace"
else
    echo "Something went wrong with BookInfo"
fi