#!/bin/bash

echo ""
echo "Delete all deployments from namespace ${K8S_NAMESPACE}, and all images from docker"
echo ""
echo "" + ${K3_CLUSTER_NAME}
echo "" + ${K8S_NAMESPACE}
echo ""

read -p "Are you sure? [y/N] " -n 1 -r

echo  

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "Environment variable \$K8S_NAMESPACE is empty"
  else

    echo "kubectl delete all --all -n ${K8S_NAMESPACE} && docker images prune -a --all"
    kubectl delete all --all -n "${K8S_NAMESPACE}" && docker images prune -a --all
  fi
fi
