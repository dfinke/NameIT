function Clear-CacheStore {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $Key
    )

    $local:cache = Get-CacheStore

    if ($key) {
        $null = $local:cache.Remove($key)
    } else {
        $local:cache.Clear()
    }
}
