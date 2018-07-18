#!/bin/bash
set -e

echo
echo "[+] Starting Docker Build, TAG, and PUSH to AWS ECR"
echo

# Make Sure all the required tools are installed
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
${DIR}/tools.sh
source ${DIR}/environment-variables.sh

# Make sure we are in the right path
cd ${TRAVIS_BUILD_DIR}

# Get Version to Tag
echo
echo "[+] Docker Build ID: ${DOCKER_TAG_VERSION}"
echo

# Login to ECR and get the Repo
echo
echo "[+] Logging into AWS ECR"
echo
export ECR_REPO=$(aws ecr get-login --no-include-email | sed 's|.*https://||')
eval $(aws ecr get-login --no-include-email | sed 's|https://||')

# BUILD
echo; echo "[+] Docker build '${TRAVIS_BUILD_DIR} --tag ${DOCKER_TAG_VERSION}'"; echo
docker build ${TRAVIS_BUILD_DIR} --tag ${DOCKER_TAG_VERSION}

# PUSH Version Tag
echo; echo "[+] Tagging ${DOCKER_TAG_VERSION} for AWS ECR ${ECR_REPO}/${DOCKER_TAG_VERSION}"; echo
docker tag ${DOCKER_TAG_VERSION} ${ECR_REPO}/${DOCKER_TAG_VERSION}
echo; echo "[+] Pushing ${DOCKER_TAG_VERSION} to AWS ECR ${ECR_REPO}"; echo;
docker push ${ECR_REPO}/${DOCKER_TAG_VERSION}

# PUSH LATEST Tag
echo; echo "[+] Tagging ${DOCKER_TAG_LATEST} for AWS ECR ${ECR_REPO}/${DOCKER_TAG_LATEST}"; echo
docker tag ${DOCKER_TAG_VERSION} ${ECR_REPO}/${DOCKER_TAG_LATEST}
echo; echo "[+] Pushing ${DOCKER_TAG_LATEST} to AWS ECR ${ECR_REPO}"; echo
docker push ${ECR_REPO}/${DOCKER_TAG_LATEST}

echo; echo "[+] Docker Complete"; echo
