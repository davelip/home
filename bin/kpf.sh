#!/bin/bash

if [ -z "$1" ]
then
  echo "Specify at least a parameter"
  echo "Usage:"
  echo " $0 name port_out port_in"
  echo ""
  echo " name: element name"
  echo " port_out [optional]: exposed port 8080 [default]"
  echo " port_in [optional]: internal port 8080 [default]"
else
  if [ -z "$2" ]
  then
    PORT_OUT="8080"
    PORT_IN="8080"
  else
    PORT_OUT="${2}"
    if [ -z "$3" ]
    then
      PORT_IN="8080"
    else
      PORT_IN="${3}"
    fi
  fi

  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "environment variable \$K8S_NAMESPACE is empty"
  else
    echo ""
    echo "Expose port ${PORT_IN} to ${PORT_OUT} for pod ${1} from namespace ${K8S_NAMESPACE}"
    echo ""
    echo "" + ${K3_CLUSTER_NAME}
    echo "" + ${K8S_NAMESPACE}
    echo ""

    echo "kubectl port-forward -n $K8S_NAMESPACE $1 ${PORT_OUT}:${PORT_IN}"
    kubectl port-forward -n "$K8S_NAMESPACE" $1 ${PORT_OUT}:${PORT_IN}
  fi
fi
