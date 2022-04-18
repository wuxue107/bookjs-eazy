#!/usr/bin/env bash

SCRIPT_PATH=$(cd `dirname "$0"`;pwd)
cd "${SCRIPT_PATH}";


echo docker stop screenshot-api-server
docker stop screenshot-api-server
# docker rm screenshot-api-server
