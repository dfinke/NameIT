$PSVersionTable

if ($null -eq (Get-Module -ListAvailable pester) -or (Get-Module -ListAvailable pester).Version -lt "4.6.0") {
    Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser
}

$result = Invoke-Pester -Script $PSScriptRoot/__tests__ -Verbose -PassThru

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}