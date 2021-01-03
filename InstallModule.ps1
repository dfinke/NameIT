param ($fullPath)

# $fullPath = 'C:\Program Files\WindowsPowerShell\Modules\NameIT'

if (-not $fullPath) {
    $fullpath = $env:PSModulePath -split ":(?!\\)|;|," |
        Where-Object {$_ -notlike ([System.Environment]::GetFolderPath("UserProfile")+"*") -and $_ -notlike "$pshome*"} |
            Select-Object -First 1
            $fullPath = Join-Path $fullPath -ChildPath "NameIT"
}

Push-location $PSScriptRoot
Robocopy . $fullPath /mir /XD .vscode .git CI __tests__ data mdHelp /XF appveyor.yml azure-pipelines.yml .gitattributes .gitignore filelist.txt install.ps1 InstallModule.ps1
Pop-Location

#Robocopy . $fullPath /mir /XD .vscode .git examples testimonials images spikes /XF appveyor.yml .gitattributes .gitignore