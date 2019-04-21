function guid {
    [CmdletBinding()]
    param(
        [Parameter()]
        [int]
        $part
    )

    $guid = [guid]::NewGuid().guid

    if ($part) {
        ($guid -split '-')[$part]
    } else {
        $guid
    }
}
