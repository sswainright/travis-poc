#!/bin/sh

echo "**** Setting Up Environment Variables ****"

# Build Variables
export POM_ARTIFACT_NAME=travis-poc
export JAR=${POM_ARTIFACT_NAME}-${POM_VERSION}.jar

# Define the Docker build details.
export APP_REPOSITORY=${POM_ARTIFACT_NAME}
export APP_VERSION="${POM_VERSION}-${TRAVIS_COMMIT:(-6)}"
export DOCKER_TAG_VERSION=${APP_REPOSITORY}:${APP_VERSION}
export DOCKER_TAG_LATEST=${APP_REPOSITORY}:latest

# Define kubernetes deployment
# todo
