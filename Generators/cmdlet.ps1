function cmdlet {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('approved', 'any')]
        [string]
        $ApprovedVerb,
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )
    if ($ApprovedVerb -eq 'approved') {
        $verb = (Get-Verb | Get-Random).verb
    }
    else {
        $verb = (verb -Culture $Culture)
    }

    $noun = noun -Culture $Culture
    "{0}-{1}" -f $verb, ((Get-Culture).TextInfo.ToTitleCase($noun))
}
