#!/bin/bash

if [ -z "$K3_CLUSTER_NAME" ]
then
  echo "environment variable \$K3_CLUSTER_NAME is empty"
else
  echo ""
  echo "Switch context to k3d-${K3_CLUSTER_NAME}"
  echo ""
  echo "" + ${K3_CLUSTER_NAME}
  echo ""

  echo "kubectl config use-context k3d-$K3_CLUSTER_NAME"
  kubectl config use-context "k3d-$K3_CLUSTER_NAME"
fi
