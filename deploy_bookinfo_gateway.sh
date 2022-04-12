#!/bin/bash
source ./export_constants.sh

#export NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$(kubectl config current-context)\")].context.namespace}")
#echo $NAMESPACE

kubectl config set-context --current --namespace=$NAMESPACE

#export MY_INGRESS_GATEWAY_HOST=istio.$NAMESPACE.bookinfo.com
#echo $MY_INGRESS_GATEWAY_HOST
kubectl apply -f $ISTIO_HOME/samples/bookinfo/networking/bookinfo-gateway.yaml

sleep 10

#export lb_ip = $(kubectl get svc istio-ingressgateway -n istio-system -o json|jq -r '.status.loadBalancer.ingress[0].ip')

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT


#validate if successfully deployed
export deployed_gatway=$(kubectl get gateway -o=json|jq -r '.items[].metadata.name')

kubectl apply -f $ISTIO_HOME/samples/addons
kubectl rollout status deployment/kiali -n istio-system

if [ "$deployed_gatway"="bookinfo-gateway" ] ; then
    echo "gatway successfully deployed "
    echo "GATEWAY_URL:$GATEWAY_URL"
    echo "please access : http://$GATEWAY_URL/productpage"
    echo "running 100 curl to productpage to populate kiali"
    for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done
    echo "for Kiali dashboard, please access using command istioctl dashboard kiali" 
else
    echo "not deployed, something went wrong"
fi
