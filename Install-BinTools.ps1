﻿Import-Module .\tools\scripts\Build-netmf.psm1
Invoke-WebRequest -UseBasicParsing -Uri "http://netmf.github.io/downloads/build-tools.zip" | Expand-Stream -Destination $SPOROOT
