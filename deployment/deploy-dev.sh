#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the shared components
${DIR}/tools.sh
source ${DIR}/environment-variables.sh

ECR_REPO=$(aws ecr get-login --no-include-email | sed 's|.*https://||')
DEPLOY_NAME=${APP_REPOSITORY}-dev

# Create the helm chart
echo "image=${ECR_REPO}/${DOCKER_TAG_VERSION}"
helm template ${TRAVIS_BUILD_DIR}/deployment/helm --set image=${ECR_REPO}/${DOCKER_TAG_VERSION} -f ${TRAVIS_BUILD_DIR}/deployment/helm/env/dev.yaml --name ${DEPLOY_NAME}

echo; echo "[+] Deleting previous helm deployment ${DEPLOY_NAME}"; echo
helm delete --purge \
        ${DEPLOY_NAME} || true

echo; echo "[+] Installing dev environment deployment ${DEPLOY_NAME}"; echo
helm install \
        --set image=${ECR_REPO}/${DOCKER_TAG_VERSION} \
        --namespace dev \
        --name ${DEPLOY_NAME} \
        -f ${TRAVIS_BUILD_DIR}/deployment/helm/env/dev.yaml \
        ${TRAVIS_BUILD_DIR}/deployment/helm

echo; echo "[+] Current Deployments for dev environment"; helm list --namespace dev

echo; echo "[+] Done Deploying dev environment to ${KUBERNETES_CLUSTER}"; echo


