function email {
    [CmdletBinding()]
    param (
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )
    # $tlds = 'com', 'com', 'com', 'net', 'org', 'es', 'es', 'es'

    $domain = 'gmail.com', 'yahoo.com', 'hotmail.com'

    "{0}@{1}" -f (person -Culture $Culture).tolower().replace(' ', '.'), ($domain | Get-Random)
}