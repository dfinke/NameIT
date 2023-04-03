function country {
<#
    .SYNOPSIS
    The function is intended to generate a random country

    .DESCRIPTION
    As per the original, this function generates a random country by default. This version is enhanced to provide the ability to limit the generation
    to specific continents, as well as to output additional real details, such as the two-letter country short code designation, the capital city, and
    the phone prefix for use in generating fake phone numbers.

    .PARAMETER Continent
    Limit generated items to a specific continent. 

    .PARAMETER ReturnValues
    Changes the type and amount of information returned

        NameOnly (default): Mimics the legacy behavior and returns only a string with a country name
        Enhanced: Returns a PSCustomObject that also includes the shortname and associated continent
        All: Returns a PSCustomObject with the same values as Enhanced, but adds the Capital city and the country dialing code prefix

    .PARAMETER AsObject
    Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
    to reuse for other generator templates without needing to extend the functionality of this one.

    .NOTES
    KEYWORDS: PowerShell

    VERSIONS HISTORY
    0.1.0 - 2021-04-01 - The first version published as a part of original NameIT powershell module by Doug Finke (https://github.com/dfinke/NameIT)
    0.2.0 - 2023-03-23 - Enhanced version published as a part of forked NameIT powershell module by Topher Whitfield

    Continent and country data from
    https://www.back4app.com/database/back4app/list-of-all-continents-countries-cities
        
    .EXAMPLE
    [PS] > Invoke-Generate "[country]"

    China

    One country returned as string

    .EXAMPLE
    [PS] Invoke-Generate "[country -continent Europe]"

    Austria

    One country returned as a string, but limited to Europe for the continent

    .EXAMPLE
    [PS] Invoke-Generate "[country -ReturnType Enhanced -AsObject]"

    Name        ShortName   Continent
    ------      ----------  ---------
    Ethiopia    ET          Africa

    One country is returned as a PSCustomObject with additional details

    .EXAMPLE
    [PS] Invoke-Generate "[country -ReturnType Enhanced]"

    Ethiopia, ET, Africa

    One country is returned as a string with additional details

    .EXAMPLE
    [PS] Invoke-Generate "[country -ReturnType All -AsObject]"

    Name        Shortname Continent Capital    PhonePrefix
    ----        --------- --------- -------    -----------
    New Zealand NZ        Oceania   Wellington 64

    One country is returned as a PSCustomObject with further additional details
#>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet("Africa","North America","Oceania","Antarctica", "Europe","Asia","South America")]
        [string]$Continent,
        [Parameter()]
        [ValidateSet("Name","Enhanced","All")]
        [string]$DataSet = "Name",
        [Parameter()]
        [switch]$AsObject,
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        $CountryData = Resolve-LocalizedPath -Culture $Culture -ContentFile countries.csv | Import-CacheableCsv -Delimiter ','
    
    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        if($Continent){
            $Country = ($CountryData).Where({$_.Continent -eq $Continent}) | Get-Random
        }else{
            $Country = $CountryData | Get-Random
        }

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $output = [PSCustomObject]@{
            Name = $Country.Name
            ShortName = $Country.Code
            Continent = $Country.Continent
            Capital = $Country.Capital
            PhonePrefix = $Country.Phone
        }

    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsBase = 'Name'
        $dsEnhanced = 'Name', 'ShortName', 'Continent'

        switch ($DataSet) {
            'Enhanced' { $propertyName = $dsEnhanced }
            'All' { $propertyName = '*' }
            Default { $propertyName = $dsBase }
        }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            # Write output as custom object
            $output | Select-Object $propertyName
        }else {
            # Write output as string
            (($output | Select-Object $propertyName).psobject.properties).value -join ", "
        }

    #endregion Output
}