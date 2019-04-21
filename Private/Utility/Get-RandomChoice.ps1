function Get-RandomChoice {
    param (
        $list,
        [int]$length = 1
    )

    $max = $list.Length

    $(
        for ($i = 0; $i -lt $length; $i++) {
            $list[(Get-Random -Minimum 0 -Maximum $max)]
        }
    ) -join ''
}
