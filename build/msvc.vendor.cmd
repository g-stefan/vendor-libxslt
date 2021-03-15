@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor vendor-libxslt

if not exist archive\ mkdir archive

pushd archive
set VENDOR=libxslt-1.1.34
set WEB_LINK=ftp://xmlsoft.org/libxslt/libxslt-1.1.34.tar.gz
if not exist %VENDOR%.tar.gz curl --insecure --location %WEB_LINK% --output %VENDOR%.tar.gz
7z x %VENDOR%.tar.gz -so | 7z x -aoa -si -ttar -o.
del /F /Q %VENDOR%.tar.gz
if exist %VENDOR%.7z del /F /Q %VENDOR%.7z
7zr a -mx9 -mmt4 -r- -sse -w. -y -t7z %VENDOR%.7z %VENDOR%
rmdir /Q /S %VENDOR%
popd
