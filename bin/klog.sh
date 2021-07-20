#!/bin/bash

if [ -z "$1" ]
then
  echo "Specify at least a parameter"
  echo "Usage:"
  echo " kl name"
  echo ""
  echo " name: element name"
else
  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "environment variable \$K8S_NAMESPACE is empty"
  else
    echo ""
    echo "Get logs for ${1} from namespace ${K8S_NAMESPACE}"
    echo ""
    echo "" + ${K3_CLUSTER_NAME}
    echo "" + ${K8S_NAMESPACE}
    echo ""

    echo "kubectl logs -n ${K8S_NAMESPACE} --follow ${1}"
    kubectl logs -n "${K8S_NAMESPACE}" --follow ${1}
  fi
fi
