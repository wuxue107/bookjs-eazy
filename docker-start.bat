@echo off

set SCRIPT_PATH=%~dp0
cd %SCRIPT_PATH%

set WEB_PORT=%1
set IMAGE_TAG=%2

IF "%IMAGE_TAG%" == "" set IMAGE_TAG=latest
IF "%WEB_PORT%" == "" set WEB_PORT=3000

call wslpath.bat "dist" WEB_PATH 2>NUL

echo docker run --cpus="0.7" -p %WEB_PORT%:3000 -td --rm -v  "%WEB_PATH%:/screenshot-api-server/public" --name=screenshot-api-server wuxue107/screenshot-api-server:%IMAGE_TAG%
docker run --cpus="0.7" -p %WEB_PORT%:3000 -td --rm -v "%WEB_PATH%:/screenshot-api-server/public" --name=screenshot-api-server wuxue107/screenshot-api-server:%IMAGE_TAG%

echo LISTEN : %WEB_PORT%
echo WEB_ROOT : %WEB_PATH%
