#!/bin/bash


if [ -z "$1" ]
then
  TYPE="pods"
else
  TYPE="${1}"
fi

echo "Get ${TYPE} from namespace ${K8S_NAMESPACE}"

if [ -z "$K8S_NAMESPACE" ]
then
  echo "environment variable \$K8S_NAMESPACE is empty"
else
  kubectl get $TYPE -n "$K8S_NAMESPACE"
fi
