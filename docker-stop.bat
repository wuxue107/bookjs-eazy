@echo off

set SCRIPT_PATH=%~dp0
cd %SCRIPT_PATH%


echo docker stop screenshot-api-server
docker stop screenshot-api-server
