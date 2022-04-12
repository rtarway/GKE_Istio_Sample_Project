export GKE_CLUSTER_NAME=monetgo-private-cluster
export PROJECT_ID=my-kubernetes-codelab-345416
export ZONE=us-central1-c
export REGION=us-central1
export ISTIO_HOME=$HOME/istio-1.13.2
export PATH=$ISTIO_HOME/bin:$PATH

gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

kubectl delete -f $ISTIO_HOME/samples/addons
istioctl manifest generate --set profile=default | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system