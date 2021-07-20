#!/bin/bash

if [ -z "$1" ]
then
  echo "Specify at least a parameter"
  echo "Usage:"
  echo " $0 name command"
  echo ""
  echo " name: element name"
  echo " command [optional]: bash [default], ash, ..."
else
  if [ -z "$2" ]
  then
    TYPE="sh"
  else
    TYPE="${2}"
  fi

  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "environment variable \$K8S_NAMESPACE is empty"
  else
    echo ""
    echo "Execute ${2} on ${1} from namespace ${K8S_NAMESPACE}"
    echo ""
    echo "" + ${K3_CLUSTER_NAME}
    echo "" + ${K8S_NAMESPACE}
    echo ""

    echo "kubectl exec -it -n $K8S_NAMESPACE $1 -- ${TYPE}"
    kubectl exec -it -n "$K8S_NAMESPACE" $1 -- ${TYPE}
  fi
fi
