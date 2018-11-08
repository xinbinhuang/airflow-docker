#!/bin/sh

if [ "$TRAVIS_BRANCH" = "master" ]; then
    TAG="latest"
else
    TAG="$TRAVIS_BRANCH"
fi

docker tag docker tag "${IMAGE_NAME}" "${DOCKER_USER}/${IMAGE_NAME}:$TAG"
docker push ${DOCKER_USER}/${IMAGE_NAME}