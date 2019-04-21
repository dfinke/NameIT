function alpha {
    param ([int]$length = 1)

    Get-RandomChoice $alphabet $length
}
