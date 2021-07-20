#!/bin/bash

echo ""
echo "Start the K3D cluster $K3_CLUSTER_NAME"
echo ""
echo "" + ${K3_CLUSTER_NAME}
echo "" + ${K8S_NAMESPACE}
echo ""

if [ -z "$K3_CLUSTER_NAME" ]
then
  echo "environment variable \$K3_CLUSTER_NAME empty"
else
  echo "k3d cluster start $K3_CLUSTER_NAME"
  k3d cluster start "$K3_CLUSTER_NAME"
fi
