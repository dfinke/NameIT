function address {
<#
    .SYNOPSIS
    The function is intended to generate a random address

    .DESCRIPTION
    As per the original, this function generates a random street address by default. This version is enhanced to provide a more realistic street address
    with a real country and city, as well as a more realistic street names made of words and values from other generators instead of a random string value.

    .PARAMETER DataSet
    Controls what data is returned. Accepts two options as outlined below.

        - Base: Most closely mimics the original functionality, in that only the street portion of the address is returned
        - Full: Returns all address elements, with the exception of Geolocation, which is only included if the IncludeGeo switch is also used

    .PARAMETER CountryCode
    Limit generated item to a specific country by supplying the associated two-character country code. 

    .PARAMETER IncludeGeo
    Includes the latitude and longitude details of the city, if available.

    Note: This will NOT be the geolocation for the street address as the street will be entirely random and will not likely exist

    .PARAMETER AsObject
    Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
    to reuse for other generator templates without needing to extend the functionality of this one.

    .NOTES
    KEYWORDS: PowerShell

    VERSIONS HISTORY
    0.1.0 - 2019-03-18 - The first version published as a part of V2 updates by Brian Scholer (https://github.com/briantist) in the original NameIT 
    powershell module by Doug Finke (https://github.com/dfinke/NameIT)
    0.2.0 - 2023-03-23 - Enhanced version published as a part of forked NameIT powershell module updates made by Topher Whitfield

    .EXAMPLE
    [PS] > Invoke-Generate "[address]"

    5486 Past Salad Drive

    One address returned as string

    .EXAMPLE
    [PS] Invoke-Generate "[address -countrycode SE -AsObject]"

    streetAddress                   city        State   postalCode  country
    -------------                   ----        -----   ----------  -------
    4839 Wonder Circle, Suite 439   Furulund    Skåne   244 62      Sweden

    One address returned as an object, but limited to Switzerland for the country
#>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Base','Full')]
        [string]$DataSet = "Base",
        [Parameter()]
        [ValidatePattern('^([a-zA-Z]{2})$')]
        [string]$CountryCode,
        [Parameter()]
        [switch]$IncludeGeo,
        [Parameter()]
        [switch]$AsObject,
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        try {
            $SuffixPath = Resolve-LocalizedPath -Culture $Culture -ContentFile streetsuffix.txt
        }
        catch {
            Resolve-LocalizedPath -Culture en -ContentFile streetsuffix.txt
        }
        $SuffixData = $SuffixPath | Import-CacheableCsv -Delimiter ','

        try {
            $CountryPath = Resolve-LocalizedPath -Culture $Culture -ContentFile countries.csv
        }
        catch {
            $CountryPath = Resolve-LocalizedPath -Culture en -ContentFile countries.csv
        }
        $CountryData = $CountryPath | Import-CacheableCsv -Delimiter ','

    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

        # Randomly generate an address number - Generator: Numeric
        $numberLength = Get-Random -Minimum 3 -Maximum 6
        $houseNumber = Get-RandomValue -Template "[numeric $numberLength]" -As int

        # Leverage generators for street elements - Noun generator
        $streetBase = Invoke-Generate "[noun]"

        # Randomly determine if a modifier prefix will be applied - Generator: Adjective
        $streetCoin = Get-Random -Minimum 1 -Maximum 100
        if($streetCoin%2){ $streetPre = Invoke-Generate "[adjective]" }

        # Randomly determine if a Suite will be added - Generator: Numeric
        $suiteCoin = Get-Random -Minimum 1 -Maximum 100
        if($suiteCoin%2){
            $suiteNumLen = Get-Random -Minimum 2 -Maximum 4
            $suiteNum = Get-RandomValue -Template "[numeric $suiteNumLen]" -As int
        }

        # Generate a random city, filtered by CountryCode if specified - Generator: City
        if($CountryCode){
            $gen = "[city -CountryCode $CountryCode -DataSet Full -IncludeGeo -AsObject]"
        }else {
            $gen = "[city -DataSet Full -IncludeGeo -AsObject]"
        }
    
        $cityInfo = Invoke-Generate $gen
    
    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        # Determine street name suffix from data
        $streetSuffix = $SuffixData | Get-Random

        # Set initial name using base and random suffix
        $streetName = "$streetBase $streetSuffix"

        # Update street with prefix if generated
        if($streetPre){ $streetName = "$streetPre $streetName" }

        # Now that we are done with prefixing, apply the house number
        $streetName = "$houseNumber $streetName"

        # Randomly determine if cardinal suffix will be applied
        $cardinalCoin = Get-Random -Minimum 1 -Maximum 100

        if($cardinalCoin%2){
            $streetCard = 'N', 'E', 'S', 'W', 'North', 'East', 'South', 'West' | Get-Random
            $streetName = "$streetName $streetCard"
        }

        # Update street with suite if generated
        if($suiteNum){ $streetName = "$streetName, Suite $suiteNum"}

        # Ensure we have a matching country name for the randomized location
        $countryName = $((($CountryData).Where({$_.Code -eq $cityInfo.countryCode})).Name)

    #endregion InternalGen
    
    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $output = [PSCustomObject]@{
            streetName = $Culture.TextInfo.ToTitleCase($streetName)
            city = $Culture.TextInfo.ToTitleCase($($cityInfo.city))
            state = $Culture.TextInfo.ToTitleCase($($cityInfo.stateShort))
            county = $Culture.TextInfo.ToTitleCase($($cityInfo.countyProvince))
            postalCode = $cityInfo.postalCode
            country = $Culture.TextInfo.ToTitleCase($countryName)
            latitude = $cityInfo.latitude
            longitude = $cityInfo.longitude
        }

    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsGeo = 'latitude', 'longitude'
        $dsBase = 'streetAddress'
        $dsFull = 'streetAddress', 'city', 'county', 'state', 'postalCode', 'country'

        switch ($DataSet) {
            'Base' { [array]$propertyName = $dsBase }
            Default { [array]$propertyName = $dsFull }
        }

        if($IncludeGeo){ [array]$propertyName = $propertyName, $dsGeo }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            # Write output as custom object
            $output | Select-Object -Property $propertyName
        }else{
            # Write output as string
            (($output | Select-Object -Property $propertyName).psobject.properties).value -join ", "
        }

    #endregion Output
}