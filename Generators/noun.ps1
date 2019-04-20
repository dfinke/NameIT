function noun {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'nouns.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}
