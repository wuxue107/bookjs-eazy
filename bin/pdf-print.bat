@echo off

set URL=%3
set URL=%URL:&=^&%
set FILE=%4
set PAGE_SIZE=%1
set ORIENTATION=%2

IF "%FILE%" == "" SET FILE=output.pdf
IF "%PAGE_SIZE%" == "" SET PAGE_SIZE=A4
IF NOT "%ORIENTATION%" == "Landscape" SET ORIENTATION=Portrait

wkhtmltopdf --window-status "PDFComplete" ^
--disable-smart-shrinking ^
--margin-left 0 --margin-right 0 --margin-top 0 --margin-bottom 0 ^
--no-stop-slow-scripts ^
--enable-internal-links ^
--debug-javascript ^
--print-media-type ^
--outline --outline-depth 3 ^
--log-level info ^
--page-size %PAGE_SIZE% ^
--orientation %ORIENTATION% ^
%URL% %FILE%
