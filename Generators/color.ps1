function color {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'colors.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}
