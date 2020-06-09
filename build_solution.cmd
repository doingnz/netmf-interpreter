@echo off
setlocal
call setenv_%1 %2 

echo Generating Build Number
powershell .\mkbuildnum.ps1 4 4 setbuild.cmd
call setbuild.cmd
echo Build Number %BUILD_VER%
set VERSION=%BUILD_VER%

rem ensure visible version number is updated.
.\tools\bin\touch.exe .\Solutions\%2\TinyCLR\tinyclr.cpp  
.\tools\bin\touch.exe .\Solutions\%2\TinyBooter\TinyBooterEntry.cpp
.\tools\bin\touch.exe .\Application\TinyBooter\TinyBooter.cpp
.\tools\bin\touch.exe .\DeviceCode\Initialization\tinyhal.cpp 

if EXIST "BuildOutput\Public\%FLAVOR_DAT%\Client\dll\devicesolutions.spot.hardware.meridian.dll" GOTO :DEVICE_SOLUTIONS_OK

xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\DeviceSolutions.SPOT.Hardware.Meridian.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\dll\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\be\DeviceSolutions.SPOT.Hardware.Meridian.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pe\be\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\le\DeviceSolutions.SPOT.Hardware.Meridian.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pr\le\ /C/I/F

:DEVICE_SOLUTIONS_OK

if EXIST "BuildOutput\Public\%FLAVOR_DAT%\Client\dll\BPplus.SPOT.Algorithms.dll" GOTO :ALGORITHM_INTEROP_OK
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\BPplus.SPOT.Algorithms.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\dll\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\be\BPplus.SPOT.Algorithms.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pe\be\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\le\BPplus.SPOT.Algorithms.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pe\le\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\BPplus.SPOT.Double.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\dll\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\be\BPplus.SPOT.Double.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pe\be\ /C/I/F
xcopy .\Solutions\%3\Interops\bin\%FLAVOR_DAT%\le\BPplus.SPOT.Double.* .\BuildOutput\Public\%FLAVOR_DAT%\Client\pe\le\ /C/I/F
:ALGORITHM_INTEROP_OK

rem  msbuild dotNetMF.proj /p:memory=%MEMORY_TYPE% /p:flavor=%RELEASE_TYPE% /p:INSTRUCTION_SET=arm /t:CleanBuild /p:PLATFORM=%1 /p:DSBuildNumber=%VER_BUILD% /p:DSRevisionNumber=%VER_REVISION% /p:OEMSYSTEMINFOSTRING="Uscom Ltd - %1" %4 /fileLogger /fileLoggerParameters:LogFile=msbuild_sln_%MEMORY_TYPE%_%RELEASE_TYPE%.Log


cd Solutions\%3
msbuild /p:OEMSYSTEMINFOSTRING="BPplusR7" /flp:verbosity=detailed /clp:verbosity=minimal /fileLogger /fileLoggerParameters:LogFile=msbuild_sln_%FLAVOR_MEMORY%_%FLAVOR_DAT%.Log /p:DSBuildNumber=%VER_BUILD% /p:DSRevisionNumber=%VER_REVISION% /m

endlocal