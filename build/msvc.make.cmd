@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo - %BUILD_PROJECT% ^> %ACTION%

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

if not "%ACTION%" == "make" goto :eof

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive libxslt

if not exist output\ mkdir output
if not exist temp\ mkdir temp

set INCLUDE=%XYO_PATH_REPOSITORY%\include;%INCLUDE%
set LIB=%XYO_PATH_REPOSITORY%\lib;%LIB%
set WORKSPACE_PATH=%CD%
set WORKSPACE_PATH_OUTPUT=%WORKSPACE_PATH%\output
set WORKSPACE_PATH_BUILD=%WORKSPACE_PATH%\temp

if exist %WORKSPACE_PATH_BUILD%\build.done.flag goto :eof

pushd "source\win32"

SET CMD_CONFIG=cscript configure.js
rem SET CMD_CONFIG=%CMD_CONFIG% help
SET CMD_CONFIG=%CMD_CONFIG% zlib=yes
SET CMD_CONFIG=%CMD_CONFIG% vcmanifest=yes
SET CMD_CONFIG=%CMD_CONFIG% debug=no
SET CMD_CONFIG=%CMD_CONFIG% static=no
SET CMD_CONFIG=%CMD_CONFIG% debugger=no
SET CMD_CONFIG=%CMD_CONFIG% xslt_debug=yes
SET CMD_CONFIG=%CMD_CONFIG% bindir=%WORKSPACE_PATH_OUTPUT%\bin
SET CMD_CONFIG=%CMD_CONFIG% incdir=%WORKSPACE_PATH_OUTPUT%\include
SET CMD_CONFIG=%CMD_CONFIG% libdir=%WORKSPACE_PATH_OUTPUT%\lib
SET CMD_CONFIG=%CMD_CONFIG% sodir=%WORKSPACE_PATH_OUTPUT%\bin

if not exist %WORKSPACE_PATH_BUILD%\build.configured.flag %CMD_CONFIG%
if errorlevel 1 goto makeError
if not exist %WORKSPACE_PATH_BUILD%\build.configured.flag copy /Y /B %WORKSPACE_PATH%\build\source\xsltconfig.h %WORKSPACE_PATH%\source\libxslt\xsltconfig.h
if not exist %WORKSPACE_PATH_BUILD%\build.configured.flag echo configured > %WORKSPACE_PATH_BUILD%\build.configured.flag

nmake /f Makefile.msvc
if errorlevel 1 goto makeError
nmake /f Makefile.msvc install
if errorlevel 1 goto makeError
nmake /f Makefile.msvc clean
if errorlevel 1 goto makeError

goto buildDone

:makeError
popd
echo "Error: make"
exit 1

:buildDone
popd
echo done > %WORKSPACE_PATH_BUILD%\build.done.flag
