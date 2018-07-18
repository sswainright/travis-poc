#!/bin/sh

echo "**** Setting Up Environment Variables ****"

###############################################################################################################
# Build Variables
###############################################################################################################
export POM_ARTIFACT_NAME=travis-poc
# export POM_VERSION=$(python -c 'import xml.etree.ElementTree as ET; tree = ET.parse("pom.xml"); root = tree.getroot(); print root.find("{http://maven.apache.org/POM/4.0.0}version").text;')
export JAR=${POM_ARTIFACT_NAME}-${POM_VERSION}.jar

# Define the Docker build name.
export APP_REPOSITORY=$TRAVIS_REPO_SLUG
export APP_VERSION="${POM_VERSION}-${TRAVIS_COMMIT:(-6)}"
export DOCKER_TAG_VERSION=$APP_REPOSITORY:$APP_VERSION
export DOCKER_TAG_LATEST=$APP_REPOSITORY:latest
export APP_VERSION=$APP_VERSION

