@echo off

set SCRIPT_PATH=%~dp0
node "%SCRIPT_PATH%\html2pdf" %*
