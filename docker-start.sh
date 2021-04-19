#!/usr/bin/env bash

SCRIPT_PATH=$(cd `dirname "$0"`;pwd)
cd "${SCRIPT_PATH}";

WEB_PORT=$1
IMAGE_TAG=$2
[ "${IMAGE_TAG}" == "" ] && IMAGE_TAG=latest
[ "${WEB_PORT}" == "" ] && WEB_PORT=3000

WEB_PATH=${PWD}/dist
[ -d "${WEB_PATH}" ] || mkdir "${WEB_PATH}"

echo docker run -p ${WEB_PORT}:3000 -td --rm -v ${WEB_PATH}:/screenshot-api-server/public --name=screenshot-api-server wuxue107/screenshot-api-server:${IMAGE_TAG}
docker run -p ${WEB_PORT}:3000 -td --rm -v ${WEB_PATH}:/screenshot-api-server/public --name=screenshot-api-server wuxue107/screenshot-api-server:${IMAGE_TAG}

echo LISTEN : ${WEB_PORT}
echo WEB_ROOT : ${WEB_PATH}
