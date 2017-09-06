#!/bin/sh
# build and publish image to dockerhub
#
# environment variables:
#
#  TRAVIS_BRANCH
#  TRAVIS_COMMIT
#  TRAVIS_PULL_REQUEST
#  DOCKER_USERNAME
#  DOCKER_PASSWORD
#  DOCKER_REPO
#  DOCKER_IMAGE
#

COMMIT="${TRAVIS_COMMIT::8}"
IMAGE="${DOCKER_REPO}/${DOCKER_IMAGE}"
BUILD_TAG="${IMAGE}:0.1.${TRAVIS_BUILD_NUMBER}"
LATEST_TAG="${IMAGE}:latest"

echo "Creating docker image for ${TRAVIS_COMMIT} on branch ${TRAVIS_BRANCH} as ${GIT_TAG}"
docker build -t ${BUILD_TAG} ${DOCKER_BUILDDIR}
echo "Build complete ${DOCKER_IMAGE}"

if [ "$TRAVIS_BRANCH" == "master" ]; then
  echo "Tagging with  ${LATEST_TAG}"
  docker tag ${BUILD_TAG} ${LATEST_TAG}

  echo "Publishing image"
  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
  docker push ${IMAGE}
  echo "Push complete"
else
  echo "Not master branch, skipping docker"
fi
