$ModuleName   = "NameIT"
$ModulePath   = "C:\Program Files\WindowsPowerShell\Modules"
$TargetPath = "$($ModulePath)\$($ModuleName)"

if(Test-Path $TargetPath) {
    rm $TargetPath -recurse -force
}

md $TargetPath | out-null

$FilesToCopy = dir -erroraction ignore *.psm1, *.psd1, *.ps1

$FilesToCopy | ForEach {
    Copy-Item -Verbose -Path $_.FullName -Destination "$($TargetPath)\$($_.name)"
}

$null=Robocopy.exe .\customData $TargetPath\customData /mir

Copy-Item -Verbose -Path .\cultures -Recurse -Destination "$($TargetPath)\$($_.name)"