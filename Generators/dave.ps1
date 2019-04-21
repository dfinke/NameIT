# Too Many Daves by Dr. Seuss
# https://www.poetryfoundation.org/poems-and-poets/poems/detail/42882
function Dave {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )
    Resolve-LocalizedPath -Culture $Culture -ContentFile 'daves.txt' | Get-CacheableContent | Get-Random
}
