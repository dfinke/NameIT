function State {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $property = "name",

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    $states = Resolve-LocalizedPath -Culture $Culture -ContentFile 'states.csv' | Import-CacheableCsv -UseCulture -Culture $Culture

    switch ($property) {
        "name" {$property = "statename"}
        "abbr" {$property = "abbreviation"}
        "capital" {$property = "capital"}
        "zip" {$property = "zip"}
        "all" {
            $targetState = $states | Get-Random
            "{0},{1},{2},{3}" -f $targetState.Capital, $targetState.StateName, $targetState.Abbreviation, $targetState.Zip
        }
        default { throw "property [$($property)] not supported"}
    }

    $states | Get-Random | % $property
}
