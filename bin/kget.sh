#!/bin/bash

if [ -z "$1" ]
then
  TYPE="pods"
else
  TYPE="${1}"
fi

if [ -z "$K8S_NAMESPACE" ]
then
  echo "environment variable \$K8S_NAMESPACE is empty"
else
  echo ""
  echo "Get ${TYPE} from namespace ${K8S_NAMESPACE}"
  echo ""
  echo "" + ${K3_CLUSTER_NAME}
  echo "" + ${K8S_NAMESPACE}
  echo ""

  kubectl get ${TYPE} -n "${K8S_NAMESPACE}"
fi
