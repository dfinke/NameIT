
$p = @{
    Name = "NameIT"
    NuGetApiKey = $NuGetApiKey
    LicenseUri = "https://github.com/dfinke/NameIT/blob/master/LICENSE.txt"
    Tag = "NameIT","Generator","Export","Import"
    ReleaseNote = "PowerShell module to randomly generate names"
    ProjectUri = "https://github.com/dfinke/NameIT"
}

Publish-Module @p