@echo off

set SCRIPT_PATH=%~dp0
cd %SCRIPT_PATH%

set WEB_PORT=%1
set IMAGE_TAG=%2

IF "%IMAGE_TAG%" == "" THEN (
 set IMAGE_TAG=latest
)

IF "%WEB_PORT%" == "" THEN (
 set WEB_PORT=3000
)

call wslpath.bat "dist" WEB_PATH 2>NUL

echo docker run -p %WEB_PORT%:3000 -td --rm -v "%WEB_PATH%:/screenshot-api-server/public" --name=screenshot-api-server wuxue107/screenshot-api-server:%IMAGE_TAG%
