function Fortnite {
    param (
        [Parameter(Position = 0)]
        [char]
        $Char
    )

    $Filter = { 
        if ($_ -like "$Char*") {
            $_
        }
    }

    $adj = Resolve-LocalizedPath -ContentFile 'adjectives.txt' | 
        Get-CacheableContent -Transform $Filter -TransformCacheContentOn Read |
        Get-Random

    $Char = $adj[0]

    $noun = Resolve-LocalizedPath -ContentFile 'nouns.txt' | 
        Get-CacheableContent -Transform $Filter -TransformCacheContentOn Read |
        Get-Random

    "$adj" + $noun
}
