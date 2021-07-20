#!/bin/bash

echo ""
echo "K3D cluster list"
echo ""
echo "" + ${K3_CLUSTER_NAME}
echo "" + ${K8S_NAMESPACE}
echo ""

echo "k3d cluster list"
k3d cluster list
