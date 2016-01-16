
$p = @{
    Name = "NameIT"
    NuGetApiKey = $NuGetApiKey
    #LicenseUri = "https://github.com/dfinke/NameIT/blob/master/LICENSE.txt"
    #Tag = "NameIT","Generator","Export","Import"
    ReleaseNote = "Generate a random name for a 'person'"
    #ProjectUri = "https://github.com/dfinke/NameIT"
}

Publish-Module @p