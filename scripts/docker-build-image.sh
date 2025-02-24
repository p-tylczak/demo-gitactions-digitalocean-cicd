#!/usr/bin/env bash

if [[ ! $# -eq 2 ]] ; then
    echo 'Usage: $ ./docker-build-image <env:PROD|STAGING|DEV> <tag-version>'
    exit 1
fi

ENVIRONMENT=${1}
IMAGE_VERSION=${2}

environmentFile=$(
    case "$ENVIRONMENT" in
    ("PROD") echo '.env.production' ;; 
    ("STAGING") echo '.env.staging' ;; 
    ("DEV") echo '.env.development' ;; 
    (*) echo "not-found" ;; 
    esac)

if [ "$ENVIRONMENT" = "not-found" ]; then
    echo "EXCEPTION >>> Unrecognised environment ${environmentFile}..."
    exit 1
else
    echo "Setting $ENVIRONMENT environment..."
    echo
fi

if [ ! -f ${environmentFile} ]; then
    echo "EXCEPTION >>> Environment config ${environmentFile} missing..."
    exit 1
fi

echo "Sourcing ${environmentFile}..."
echo
source ${environmentFile}
echo "$ENVIRONMENT environment configured."
echo

echo "Building docker image with tag ${IMAGE_VERSION}..."
echo
pwd

FULL_IMAGE_NAME=$(echo paweltylczak/demo-ui:$ENVIRONMENT-$IMAGE_VERSION | tr A-Z a-z)

#docker build --no-cache --pull -t ghcr.io/p-tylczak/demo-ui:$IMAGE_VERSION .
docker build --no-cache --pull -t $FULL_IMAGE_NAME .
docker push $FULL_IMAGE_NAME
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin