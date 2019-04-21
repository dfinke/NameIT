function verb {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'verbs.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}
