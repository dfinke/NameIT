function space {
    [CmdletBinding()]
    param(
        [Parameter()]
        [uint32]
        $Length = 1 ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -Culture $Culture -ContentFile 'space.txt' | 
        Get-CacheableContent -Raw -Transform { $_ * $Length } -TransformCacheContentOn Read
}
