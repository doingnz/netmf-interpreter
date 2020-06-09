param($BuildMajor, $BuildMinor, $OutFile)

$utcoa = [DateTime]::UTCNow.ToOADate()
$BuildNum =[Math]::Floor($utcoa)
$BuildRev = [Math]::Floor(($utcoa - $buildNum) * [UInt16]::MaxValue)
$txt = new-object Text.StringBuilder

([void]$txt.AppendFormat("SET VER_MAJOR={0}`n", $BuildMajor))
([void]$txt.AppendFormat("SET VER_MINOR={0}`n",$BuildMinor))
([void]$txt.AppendFormat("SET VER_BUILD={0}`n",$BuildNum))
([void]$txt.AppendFormat("SET VER_REVISION={0}`n",$BuildRev))
([void]$txt.Append("SET BUILD_VER=%VER_MAJOR%.%VER_MINOR%.%VER_BUILD%.%VER_REVISION%`n"))

set-content $OutFile $txt


