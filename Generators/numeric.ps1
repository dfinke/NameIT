function numeric {
    param ([int]$length = 1)

    (Get-RandomChoice $numbers $length) -as [int]
}
