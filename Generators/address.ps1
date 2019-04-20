function address {
    [CmdletBinding()]
    param (
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    $numberLength = Get-Random -Minimum 3 -Maximum 6
    $streetLength = Get-Random -Minimum 2 -Maximum 6

    $houseNumber = Get-RandomValue -Template "[numeric $numberLength]" -As int

    $streetTemplate = "[syllable]" * $streetLength
    $street = Invoke-Generate $streetTemplate

    $suffix = Resolve-LocalizedPath -Culture $Culture -ContentFile 'streetsuffix.txt' | Get-CacheableContent | Get-Random

    $address = $houseNumber, $street, $suffix -join ' '

    $Culture.TextInfo.ToTitleCase($address)
}