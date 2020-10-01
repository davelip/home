#!/bin/bash

echo "Stop the K3D cluster $K3_CLUSTER_NAME"

if [ -z "$K3_CLUSTER_NAME" ]
then
  echo "environment variable \$K3_CLUSTER_NAME empty"
else
  k3d cluster stop "$K3_CLUSTER_NAME"
fi
