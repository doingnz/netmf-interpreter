@echo off

IF NOT "" == "%1" SET VS_VER=%1
IF "" == "%VS_VER%" SET VS_VER=15

IF "%VisualStudioVersion%"=="15.0" (
  SET VS_VER=15
) ELSE IF "%VisualStudioVersion%"=="16.0" (
  SET VS_VER=16
) ELSE (
  GOTO ARG_ERROR
)

%~dp0\setenv_base.cmd VS %VS_VER% %2 %3 %4 %5
GOTO :EOF

:ARG_ERROR
@echo.
@echo ERROR: Invalid version argument.
@echo USAGE: setenv_vs.cmd VS_VERSION
@echo        where VS_VERSION is (15, 16, ...) or blank for auto detect
@echo.

