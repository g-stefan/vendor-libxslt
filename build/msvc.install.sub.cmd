@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

rem --- make

cmd.exe /C build\msvc.make.cmd
if errorlevel 1 exit 1

rem ---

if not exist "%INSTALL_PATH_BIN%\" mkdir "%INSTALL_PATH_BIN%"
xcopy /Y /S /E "output\bin\" "%INSTALL_PATH_BIN%\"

rem --- dev

if not exist "%INSTALL_PATH_DEV%\" mkdir "%INSTALL_PATH_DEV%"
if not exist "%INSTALL_PATH_DEV%\bin" mkdir "%INSTALL_PATH_DEV%\bin"
if not exist "%INSTALL_PATH_DEV%\include" mkdir "%INSTALL_PATH_DEV%\include"
if not exist "%INSTALL_PATH_DEV%\lib" mkdir "%INSTALL_PATH_DEV%\lib"
xcopy /Y /S /E "output\bin\" "%INSTALL_PATH_DEV%\bin\"
xcopy /Y /S /E "output\include\libexslt\" "%INSTALL_PATH_DEV%\include\libexslt\"
xcopy /Y /S /E "output\include\libxslt\" "%INSTALL_PATH_DEV%\include\libxslt\"
copy /Y /B "output\lib\libexslt.lib" "%INSTALL_PATH_DEV%\lib\libexslt.lib"
copy /Y /B "output\lib\libxslt.lib" "%INSTALL_PATH_DEV%\lib\libxslt.lib"
copy /Y /B "output\lib\libexslt_a.lib" "%INSTALL_PATH_DEV%\lib\libexslt_a.lib"
copy /Y /B "output\lib\libxslt_a.lib" "%INSTALL_PATH_DEV%\lib\libxslt_a.lib"
copy /Y /B "output\lib\libexslt_a.lib" "%INSTALL_PATH_DEV%\lib\libexslt.static.lib"
copy /Y /B "output\lib\libxslt_a.lib" "%INSTALL_PATH_DEV%\lib\libxslt.static.lib"
