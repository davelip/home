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

  echo "Get ${TYPE} from namespace ${K8S_NAMESPACE}"

  if [ -z "$K8S_NAMESPACE" ]
  then
    echo "environment variable \$K8S_NAMESPACE is empty"
  else
    kubectl describe $TYPE -n "$K8S_NAMESPACE" $1
  fi
fi
