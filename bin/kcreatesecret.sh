#!/usr/bin/bash

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo
   echo
   echo "Create new secret (you are already in the right context and namespace)"
   echo
   echo "Syntax: ${0} secret-name username password"
   echo
   echo
}

if [ ${#} -lt 3 ]; then
  echo 1>&2 "${0}: not enough arguments"
	Help;
  exit 2
fi

SECRET_NAME="${1}"

REGISTRY_USERNAME="${2}"
REGISTRY_PASSWORD="${3}"

BASE_64_BASIC_AUTH_CREDENTIALS=$(echo -n "${REGISTRY_USERNAME}:${REGISTRY_PASSWORD}" | base64)
#echo ${BASE_64_BASIC_AUTH_CREDENTIALS}

BASE_64_BASIC_AUTH_CREDENTIALS=$'{
    "auths": {
        "https://registry.gitlab.com": {
            "username":"'${REGISTRY_USERNAME}'",
            "password":"'${REGISTRY_PASSWORD}'",
            "auth":"'${BASE_64_BASIC_AUTH_CREDENTIALS}'"
        }
    }
}'
#echo "${BASE_64_BASIC_AUTH_CREDENTIALS}"

BASE_64_ENCODED_DOCKER_FILE=$(echo -n "${BASE_64_BASIC_AUTH_CREDENTIALS}" | base64)
#echo "${BASE_64_ENCODED_DOCKER_FILE}"

NAMESPACE=`kubens -c`

KUBE_SECRET=$'apiVersion: v1
kind: Secret
metadata:
  name: '${SECRET_NAME}'
  namespace: '${NAMESPACE}'
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: '${BASE_64_ENCODED_DOCKER_FILE//$'\n'/}

echo "${KUBE_SECRET}"
