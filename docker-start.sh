#!/usr/bin/env bash

SCRIPT_PATH=$(cd `dirname "$0"`;pwd)
cd "${SCRIPT_PATH}";

IMAGE_TAG=$1
[ "${IMAGE_TAG}" == "" ] && IMAGE_TAG=latest

echo docker run -p 3000:3000 -td --rm -v ${PWD}/dist:/screenshot-api-server/public --name=screenshot-api-server wuxue107/screenshot-api-server:${IMAGE_TAG}
docker run -p 3000:3000 -td --rm -v ${PWD}/dist:/screenshot-api-server/public --name=screenshot-api-server wuxue107/screenshot-api-server:${IMAGE_TAG}
