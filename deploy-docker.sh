#!/usr/bin/env bash

if [ "$TRAVIS_BRANCH" = "master" ]; then
    TAG="latest"
else
    TAG="$TRAVIS_BRANCH"
fi

docker tag "${IMAGE_NAME}" "${TRAVIS_REPO_SLUG}:$TAG"
docker push "${TRAVIS_REPO_SLUG}:$TAG"