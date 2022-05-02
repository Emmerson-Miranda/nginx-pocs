#!/bin/bash
echo "Undeploy previous manifest"
kubectl delete -f consul-template-cfgmap.yaml 
kubectl delete -f nginx-consul-template.yaml  --grace-period=0 --force
sleep 5

echo "Deploying updates"
kubectl apply -f consul-template-cfgmap.yaml
kubectl apply -f nginx-consul-template.yaml
echo ""
kubectl get pods
echo ""

echo "kubectl logs \$(kubectl get pod -l app=nginxct -n default -o jsonpath={.items..metadata.name})"
echo ""