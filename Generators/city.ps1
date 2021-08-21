function City {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'Cities-US.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}
