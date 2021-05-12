function city {
    param(
        [ValidateSet('both', 'city', 'county')]
        $propertyName = 'city',
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    
    # $targetFile = Resolve-LocalizedPath -Culture $Culture -ContentFile 'cities.csv'
    $cities = Resolve-LocalizedPath -Culture $Culture -ContentFile 'cities.csv' | Import-CacheableCsv -UseCulture -Culture $Culture
    
    $city = $cities | Get-Random
    
    if ($propertyName -eq 'both') {
        "{0}, {1}" -f $city.city, $city.county
    }
    else {
        "{0}" -f $city.$propertyName        
    }
}