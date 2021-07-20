#!/bin/bash

if [ -z "$1" ]
then
  echo "Specify at least a parameter"
  echo "Usage:"
  echo " kd name type"
  echo ""
  echo " name: element name"
  echo " type: pods, services, all"
else
  if [ -z "$2" ]
  then
    TYPE="pods"
  else
    TYPE="${2}"
  fi

  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "Environment variable \$K8S_NAMESPACE is empty"
  else
    echo ""
    echo "Get ${TYPE} from namespace ${K8S_NAMESPACE}"
    echo ""
    echo "" + ${K3_CLUSTER_NAME}
    echo "" + ${K8S_NAMESPACE}
    echo ""

    echo "kubectl describe ${TYPE} -n ${K8S_NAMESPACE} ${1}"
    kubectl describe ${TYPE} -n "${K8S_NAMESPACE}" ${1}
  fi
fi
