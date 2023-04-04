function company {
    <#
        .SYNOPSIS
        The function is intended to generate basic information for a company
    
        .DESCRIPTION
        The function generates a random company name, and alternatively also supplemental information, such as a description,
        tagline, EIN, and a fake website domain.
    
        .PARAMETER DataSet
        Specify the types of information to generate based on a set of collective data points
    
            Name (default): Return only a company name - default to mimic legacy behavior
            Basic: Include a description, tagline, and website/email domain
            Enhanced: Returns all values, which includes all of the above, plus an address and fake EIN
    
        .PARAMETER CountryCode
        Provides the ability to target address generation to a specific country by specifying the two-letter country code.
    
        Note: This parameter only has an effect when returning the Enhanced data set
    
        .PARAMETER AsObject
        Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
        to reuse for other generator templates without needing to extend the functionality of this one.
    
        .PARAMETER Culture
        The culture used for generate - default is the current culture.
    
        .NOTES
        KEYWORDS: PowerShell
    
        VERSIONS HISTORY
        0.1.0 - 2016-01-16 - The first version published as a part of NameIT powershell module https://github.com/dfinke/NameIT
        0.2.0 - 2023-03-27 - Normalized function to match framework established elsewhere and updated to add new options
    
        The source of industries and classifications for the en-US culture (2023) from
        https://en.wikipedia.org/wiki/Global_Industry_Classification_Standard
    
        .EXAMPLE
        [PS] > Invoke-Generate "[company]"
        Rogers and Sons
    
        The one name returned as plain text.
    
        .EXAMPLE
        [PS] > Invoke-Generate "[company Enhanced -AsObject]"
    
        Name        Description                         Tagline                             EIN         Domain          Address
        -----       ------------                        --------                            ----        -------         --------
        Sparks PLC  Optional Interactive Middleware     Incentivize Proactive Synergies     67-1573584  sparksplc.io    5748 Happy Value Blvd, Jamestown, North Carolina, 27282, US
    
        A single company that includes all values returned as a custom object.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Name', 'Basic', 'Enhanced', 'Full')]
        [string]$DataSet = 'Name',
        [Parameter()]
        [ValidateSet('Micro','Small','Medium','Large','MicroEnt','SmallEnt','MediumEnt','LargeEnt')]
        [string]$Size,
        [Parameter()]
        [ValidatePattern('^([a-zA-Z]{2})$')]
        [string]$CountryCode,
        [Parameter()]
        [switch]$AsObject,
        [Parameter()]
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        try {
            $suffixPath = Resolve-LocalizedPath -Culture $Culture -ContentFile companysuffix.txt
        }
        catch {
            $suffixPath = Resolve-LocalizedPath -Culture en -ContentFile companysuffix.txt
        }
        $suffixData = $suffixPath | Get-CacheableContent

        try {
            $descriptionPath = Resolve-LocalizedPath -Culture $Culture -ContentFile description.txt
        }
        catch {
            $descriptionPath = Resolve-LocalizedPath -Culture en -ContentFile description.txt
        }
        $descriptionData = $descriptionPath | Get-CacheableContent

        try {
            $taglinePath = Resolve-LocalizedPath -Culture $Culture -ContentFile tagline.txt
        }
        catch {
            $taglinePath = Resolve-LocalizedPath -Culture en -ContentFile tagline.txt
        }
        $taglineData = $taglinePath | Get-CacheableContent

        try {
            $sizePath = Resolve-LocalizedPath -Culture $Culture -ContentFile companysize.csv
        }
        catch {
            $sizePath = Resolve-LocalizedPath -Culture en -ContentFile companysize.csv
        }
        $sizeData = $sizePath | Import-CacheableCsv -Delimiter ','

        try {
            $industryPath = Resolve-LocalizedPath -Culture $Culture -ContentFile industries.csv
        }
        catch {
            $industryPath = Resolve-LocalizedPath -Culture en -ContentFile industries.csv
        }
        $industryData = $industryPath | Import-CacheableCsv -Delimiter ','
        
    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

            # Generate an address - Generator: Address
            if($CountryCode){
                $companyAddress = Invoke-Generate "[address $CountryCode]"
            }else {
                $companyAddress = Invoke-Generate "[address]"
            }
            Write-Verbose "Set headquarters [$companyAddress]"

            # Generate a generic Employer Identification Number - Generator: Numeric
            $companyEIN = $(Invoke-Generate "[numeric 2]"),$(Invoke-Generate "[numeric 7]") -join '-'
            Write-Verbose "Set company EIN [$companyEIN]"

            # Identify company name generation formats and generate name
            $companyNameFormats = $(
                '{0} {1}' -f (person any last), ($suffixData | Get-Random)
                '{0}-{1}' -f (person any last), (person any last)
                '{0}, {1} and {2}' -f (person any last), (person any last), (person any last)
                '{0} {1}' -f (noun), ($suffixData | Get-Random)
                '{0} {1} {2}' -f (adjective), (noun), ($suffixData | Get-Random)
                '{0} of {1} {2}' -f (noun), (adjective), (noun)
            )
        
            $companyName = $companyNameFormats | Get-Random
            Write-Verbose "Generate company name [$companyName]"

            # Generate a website top-level domain - Generator: Domain
            $companyDomain = Invoke-Generate "[domain -basename '$companyName']"
            Write-Verbose "Use company name to generate domain [$companyDomain]"
            
    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        $companyDescription = "$($descriptionData | Get-Random) $($descriptionData | Get-Random) $($descriptionData | Get-Random)"
        Write-Verbose "Generate company description [$companyDescription]"
        $companyTagline = "$($taglineData | Get-Random) $($taglineData | Get-Random) $($taglineData | Get-Random)"
        Write-Verbose "Generate company tagline [$companyTagline]"

        #TODO: Update tagline generation using new industryData sub-industry values

        # Select a company t-shirt size for company profile details
        if($Size){
            $companySize = ($sizeData).Where({$_.Size -eq $Size})
        }else {
            $companySize = $sizeData | Get-Random
        }
        Write-Verbose "Set company size profile: `n$companySize"
        
        # Set randomized profile values from selected t-shirt
        $employeeCount = Get-Random -Minimum $($companySize.EmployeeMin) -Maximum $($companySize.EmployeeMax)
        $locationsCount = Get-Random -Minimum 1 -Maximum $($companySize.LocationMax)
        
        # Get randomized revenue from selected t-shirt and convert to localized currency
        [int64]$revSelect = $(Get-Random -Minimum $($companySize.RevenueMin) -Maximum $($companySize.RevenueMax))
        $places = (("{0:N}" -f $revSelect) -split ',').Count #determins number size (thousands, millions, billions) so we can pretty it up
        switch ($places) {
            3 { $valueAmt = "Billion" }
            2 { $valueAmt = "Million" }
            Default { $valueAmt = "Thousand" }
        }
        $revenue = ($revSelect / "1$('000' * ([System.Math]::Floor(($revSelect.ToString().Length - 1) / 3)))").ToString('C',$Culture)
        $revenueValue = "$revenue $valueAmt"
        Write-Verbose "Determine revenue [$revenueValue]"

        # Set indicator of publicly traded or privately owned
        if($companySize.Size -like "*Ent"){
            $tradeType = "Public"
        }else{
            $tradeType = "Private"
        }

        # Set random founding year and years in business
        $baseDate = Get-Date '01.01.1820'
        $futureDate = (Get-Date).AddYears(-2)
        $founding = [datetime](Get-Random -Minimum $baseDate.Ticks -Maximum $futureDate.Ticks)
        $foundingYear = $founding.Year
        $inBusiness = "$([Math]::Floor(((Get-Date) - $founding).Days / 365)) Years"

        $companyIndustry = (($industryData).Industry | Select-Object -Unique) | Get-Random

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $company = [PSCustomObject]@{
            Name = $companyName
            Description = $companyDescription
            Tagline = $companyTagline
            EIN = $companyEIN
            Domain = $companyDomain
            Headquarters = $companyAddress
            Employees = $employeeCount
            Locations = $locationsCount
            Founded = $foundingYear
            InBusiness = $inBusiness
            Revenue = $revenueValue
            TradeType = $tradeType
            Industry = $companyIndustry
        }
    
    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsBase = 'Name'
        $dsBasic = 'Name','Description','Tagline','Domain'
        $dsEnhanced = 'Name','Description','Tagline','Domain','Headquarters','EIN'
        $dsFull = 'Name','Description','Tagline','Domain','Headquarters','EIN','Employees','Locations','Founded','InBusiness','Revenue','TradeType','Industry'

        switch ($DataSet) {
            "Basic" { [array]$propertyName = $dsBasic }
            "Enhanced" { [array]$propertyName = $dsEnhanced }
            "Full" { [array]$propertyName = $dsFull }
            Default { [array]$propertyName = $dsBase }
        }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            # Write output as custom object
            $CallStack = Get-PSCallStack
            Write-Verbose "Calling command - $($CallStack.Command)"
            if($(Get-PSCallStack).Command -eq 'Invoke-Generate'){

                foreach($item in $($company | Select-Object -Property $propertyName).psobject.properties){
                    $output += "$($item.Name)=$($item.Value) `n"
                }
            }else{
                $output = $company | Select-Object -Property $propertyName
            }
        }else{
            # Write output as string
            $output = (($company | Select-Object -Property $propertyName).psobject.properties).value -join ", "
        }
        
        $output

    #endregion Output
}