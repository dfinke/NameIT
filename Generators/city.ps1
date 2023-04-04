function city {
<#
    .SYNOPSIS
    The function is intended to generate a random city

    .DESCRIPTION
    As per the original, this function generates a random city by default. This version is enhanced to provide the ability to limit the generation
    to a specific country, as well as to output additional real details when available, such as the postal code, state/province details, and even 
    rough latitude and longitude, which can be useful for scenarios such as displaying sample maps with dynamic location with Power BI

    .PARAMETER propertyName
    Allows user to specify which properties are returned. By default, only the City name is returned to mimic the behavior of the legacy generator.
    If desired, user can specify 'All' to return all values, or the user can specify one or more properties to be returned. Values will tab complete.

    .PARAMETER DataSet
    Allows the user to specify which properties to return in a set

    .PARAMETER CountryCode
    Limit generated item to a specific country by supplying the associated two-character country code. 

    .PARAMETER AsObject
    Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
    to reuse for other generator templates without needing to extend the functionality of this one.

    .NOTES
    KEYWORDS: PowerShell

    VERSIONS HISTORY
    0.1.0 - 2021-09-18 - The first version published as a part of original NameIT powershell module by Doug Finke (https://github.com/dfinke/NameIT)
    0.2.0 - 2023-03-23 - Enhanced version published as a part of forked NameIT powershell module by Topher Whitfield

    Continent and country data from
    https://www.back4app.com/database/back4app/list-of-all-continents-countries-cities

    Data mapping countries to cities and zip codes from
    https://www.geonames.org/

    Note: Countries that do not permit use of Zip code data are not represented

    .EXAMPLE
    [PS] > Invoke-Generate "[city]"

    Kadalu

    One city returned as string

    .EXAMPLE
    [PS] Invoke-Generate "[city -countrycode SE]"

    Stockholm

    One city returned as a string, but limited to Switzerland for the country

    .EXAMPLE
    [PS] Invoke-Generate "[city -propertyName All -AsObject]"

    countryCode postalCode  city    state   stateShort  countyProvince  countyProvinceShort community   communityShort  latitude    longitude   accuracy
    ----------- ----------  ----    -----   ----------  --------------  ------------------- ---------   --------------  --------    ---------   --------
    US          33508       Brandon Florida FL          Hillsborough    057                                             27.9318     -82.295     4

    One city is returned as a PSCustomObject with all properties available

    .EXAMPLE
    [PS] Invoke-Generate "[city -propertyName city,postalcode]"

    PUERTA DE TASTIL, 4409

    One city and the associated postal code returned as a single string
#>
    [CmdletBinding(DefaultParameterSetName='Legacy')]
    param(
        [Parameter(ParameterSetName='Legacy')]
        [ValidateSet("","both", "city", "county", 'all', "countryCode", "postalCode",  "state", "stateShort", "countyProvince", "countyProvinceShort", "community", "communityShort")]
        [string]$propertyName,
        [Parameter(ParameterSetName='New')]
        [ValidateSet('Name','Enhanced','Full')]
        [string]$DataSet,
        [Parameter(ParameterSetName='New')]
        [ValidateSet('DZ','MA','MW','RE','YT','ZA','AZ','BD','IN','JP','KR','LK','MY','PH','PK','SG','TH','TR','AD','AT','AX','BE','BG','BY','CH','CY','CZ','DE','DK','EE','ES','FI',
        'FO','FR','GB','GG','HR','HU','IE','IM','IS','IT','JE','LI','LT','LU','LV','MC','MD','MK','MT','NL','NO','PL','PT','RO','RS','RU','SE','SI','SJ','SK','SM','UA','VA','BM','CA',
        'CR','DO','GL','GP','GT','HT','MQ','MX','PM','PR','US','VI','AS','AU','FM','GU','MH','MP','NC','NZ','PW','WF','AR','BR','CL','CO','GF','PE','UY')]
        [string]$CountryCode,
        [Parameter(ParameterSetName='New')]
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
            $CountryPath = Resolve-LocalizedPath -Culture $Culture -ContentFile countries.csv
        }
        catch {
            $CountryPath = Resolve-LocalizedPath -Culture en -ContentFile countries.csv
        }
        
        $CountryData = ($CountryPath | Import-CacheableCsv -Delimiter ',').Where({$_.PostalCode -eq 1})

        if($CountryCode){
            $CountryData = ($CountryData).Where({$_.Code -eq $CountryCode})
        }else {
            $CountryInfo = $CountryData | Get-Random
            $CountryCode = $CountryInfo.Code
        }

        try {
            $cityPath = Resolve-LocalizedPath -Culture $Culture -ContentFile "$CountryCode.csv"
        }
        catch {
            $cityPath = Resolve-LocalizedPath -Culture en -ContentFile "$CountryCode.csv"
        }
        
        $CityData = $cityPath | Import-CacheableCsv -Delimiter ','
        
    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        $city = $CityData | Get-Random
        Write-Verbose "Selected city: `n$city"

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsGeo = 'latitude', 'longitude'
        $dsBase = 'city'
        $dsCounty = 'countyProvince'
        $dsBoth = 'city','countyProvince'
        $dsEnhanced = "city","stateShort","postalCode"
        $dsFull = "countryCode", "city", "countyProvince", "countyProvinceShort", "state", "stateShort", "postalCode", "community", "communityShort"

		Write-Verbose "ParameterSetName [$($PSCmdlet.ParameterSetName)]"

        # Determine if special handling for legacy is required, and otherwise filter returned property sets
        if($PSCmdlet.ParameterSetName -eq 'Legacy'){
			Write-Verbose "Processing as Legacy"
			
            # If null (no value) mimic original by overriding to 'city' - can't do this in param as it would force ParameterSet to always be Legacy
            if($null -eq $propertyName -or $propertyName -eq ""){
				Write-Verbose "Detected Null; Setting to dsBase [$dsBase]"
                [array]$propertyName = $dsBase
            }

            # If 'county' is specified, override to be updated value from new data set
            if($propertyName -eq 'county'){
				Write-Verbose "Detected 'county'; Setting to dsCounty [$dsCounty]"
                [array]$propertyName = $dsCounty
            }

            # if 'both' is specified, override to be updated values from new data set
            if($propertyName -eq 'both'){
				Write-Verbose "Detected 'both'; Setting to dsBoth [$dsBoth]"
                [array]$propertyName = $dsBoth
            }

            # Add support for new 'all' option
            if($propertyName -eq 'all'){
				Write-Verbose "Detected 'all'; Setting to dsFull [$dsFull]"
                [array]$propertyName = $dsFull
            }

        }else {
            switch ($DataSet) {
                'Name' { [array]$propertyName = $dsBase }
                'Enhanced' { [array]$propertyName = $dsEnhanced }
                Default { [array]$propertyName = $dsFull }
            }
        }

        # Add lat and long if IncludeGeo switch is present
        if($IncludeGeo){ 
            Write-Verbose "IncludeGeo specified; Additing dsGeo [$dsGeo]"
            [array]$propertyName = $propertyName, $dsGeo 
        }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            # Write output as custom object
            $city | Select-Object -Property $propertyName
        }else{
            # Write output as string
            (($city | Select-Object -Property $propertyName).psobject.properties).value -join ", "
        }

    #endregion Output
}