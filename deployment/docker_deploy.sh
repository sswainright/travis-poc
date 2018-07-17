#!/bin/bash
set -e

# Get the shared components
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#${DIR}/tools.sh
#source ${DIR}/environment-variables.sh

echo "Starting Docker Build"

source environment-variables.sh

# Make sure we are in the right path
cd ${TRAVIS_BUILD_DIR}

##################################################################################
# SETUP
##################################################################################
echo "[+] Docker Build ID: ${DOCKER_TAG_VERSION}"

# Deploy to the ECS container registry.
echo "[+] Logging into AWS ECR"
export ECR_REPO=$(aws ecr get-login --no-include-email | sed 's|.*https://||')
eval $(aws ecr get-login --no-include-email | sed 's|https://||')

##################################################################################
# BUILDING
##################################################################################
#cp target/"${JAR}" target/quoting-service.jar
echo "[+] Docker build"
docker build ${TRAVIS_BUILD_DIR} --tag ${DOCKER_TAG_VERSION}

##################################################################################
# PUSHING
##################################################################################
echo "[+] Pushing ${DOCKER_TAG_VERSION} to AWS ECR"
docker tag ${DOCKER_TAG_VERSION} ${ECR_REPO}/${DOCKER_TAG_VERSION}
docker push ${ECR_REPO}/${DOCKER_TAG_VERSION}

echo "[+] Pushing ${DOCKER_TAG_LATEST} to AWS ECR"
docker tag ${DOCKER_TAG_VERSION} ${ECR_REPO}/${DOCKER_TAG_LATEST}
docker push ${ECR_REPO}/${DOCKER_TAG_LATEST}
