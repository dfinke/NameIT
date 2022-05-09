$PSVersionTable

$modules = @("Pester", "PSScriptAnalyzer")

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck
    Import-Module $module -Force -PassThru
}

$pesterResults = Invoke-Pester -Output Detailed -PassThru

$os = if($IsWindows) {
    "windows"
} elseif($IsLinux) {
    "linux"
} elseif ($IsMacOS) {
    "macos"
}

$pesterResults | Export-NUnitReport -Path "./pesterTestResults-$os.xml"

if (!$pesterResults) {
    Throw "Tests failed"
}
else { 
    if ($pesterResults.FailedCount -gt 0) {
        
        '[Progress] Pester Results Failed'
        $pesterResults.Failed | Out-String
    
        '[Progress] Pester Results FailedBlocks'
        $pesterResults.FailedBlocks | Out-String
    
        '[Progress] Pester Results FailedContainers'
        $pesterResults.FailedContainers | Out-String

        Throw "Tests failed"
    }
}
