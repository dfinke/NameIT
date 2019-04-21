function adjective {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'adjectives.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}
