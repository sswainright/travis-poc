#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the shared components
${DIR}/get-shared-tools.sh
#source ${DIR}/shared-environment-variables.sh

ECR_REPO=$(aws ecr get-login --no-include-email | sed 's|.*https://||')
DEPLOY_NAME=${APP_REPOSITORY}-dev

# Create the helm chart
helm template ${TRAVIS_BUILD_DIR}/deployment/helm --set image=${ECR_REPO}/${DOCKER_TAG_VERSION} -f ${TRAVIS_BUILD_DIR}/deployment/helm/env/dev.yaml --name ${DEPLOY_NAME}

helm delete --purge \
        ${DEPLOY_NAME} || true

helm install \
        --set image=${ECR_REPO}/${DOCKER_TAG_VERSION} \
        --namespace dev \
        --name ${DEPLOY_NAME} \
        -f ${TRAVIS_BUILD_DIR}/deployment/helm/env/dev.yaml \
        ${TRAVIS_BUILD_DIR}/deployment/helm


