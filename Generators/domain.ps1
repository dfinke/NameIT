function domain {
    <#
        .SYNOPSIS
        The function is intended to generate a top-level domain name for use as a URL or email address
    
        .DESCRIPTION
        The function generates a random top-level domain name for use as a base URL, or in an email address.
    
        .PARAMETER BaseName
        Enables a user to specify a value to transform into a top-level domain as part of calls from other generators. For example,
        if generating a large number of identities as part of generating an organization, it might be preferred to have a common
        email domain for all of the generated values.
    
        .PARAMETER ExpandedTop
        By default, only one of the primary 9 top-level domain extensions are leveraged. By specifying this switch, the entire current
        list of available top-level domain extensions, which at the time of writing was 1479, is retrieved from the IANA.org website 
        and used instead. 
    
        .PARAMETER Culture
        The culture used for generate - default is the current culture.
    
        .NOTES
        KEYWORDS: PowerShell
    
        VERSIONS HISTORY
        0.1.0 - 2023-03-28 - New generator template intended to replace URLs, which is inconsistent
    
        .EXAMPLE
        [PS] > Invoke-Generator "[domain]"
        HooverWalshandAndrade.org
    
        The one domain name returned as plain text.
    
        .EXAMPLE
        [PS] > Invoke-Generator "[domain 'Inexpensive Laugh Group']"
        InexpensiveLaughGroup.io
    
        A single company name is provided as a base. Any special characters, numbers, and spaces are removed, and a top-level domain
        extension is appended and the final value returned as simple text.
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]$BaseName,
        [Parameter()]
        [switch]$ExpandedTop,
        [Parameter()]
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        if($ExpandedTop){
            # Get full current list of top-level domains from iana.org
            $domSuffixes = @()
            $uri = 'https://data.iana.org/TLD/tlds-alpha-by-domain.txt'

            try {
                # Use a web response and streaming in order to enable reading the list of values without first downloading a file
                $webRequest = [System.Net.WebRequest]::Create($uri)
                $webResponse = $webRequest.GetResponse()

                # Check for a valid response
                if($webResponse.StatusCode -eq 'OK'){
                    $receive = $webResponse.GetResponseStream()
                    $encode = [System.Text.Encoding]::GetEncoding('utf-8')
                    $read = [System.IO.StreamReader]::new($receive, $encode)
                    while (-not $read.EndOfStream){ $domSuffixes += $read.ReadLine() }
                    $webResponse.Close()
                    $read.Close()
                    $domSuffixes = $domSuffixes | Select-Object -Skip 1
                }else {
                    # If we fail to get the full list, fail back to the existing local list
                    Write-Warning "Failed to retrieve full list - reverting to primary"
                    try {
                        $domPath = Resolve-LocalizedPath -Culture $Culture -ContentFile domainsuffix.txt
                    }
                    catch {
                        $domPath = Resolve-LocalizedPath -Culture en -ContentFile domainsuffix.txt
                    }
                    $domSuffixes = $domPath | Get-CacheableContent
                }
            }
            catch {
                # If we get an error, fail back to the existing local list
                Write-Warning "Failed to retrieve full list - reverting to primary"
                try {
                    $domPath = Resolve-LocalizedPath -Culture $Culture -ContentFile domainsuffix.txt
                }
                catch {
                    $domPath = Resolve-LocalizedPath -Culture en -ContentFile domainsuffix.txt
                }
                $domSuffixes = $domPath | Get-CacheableContent
            }
        }else {
            # Just use the base set of locally defined top-level domains
            try {
                $domPath = Resolve-LocalizedPath -Culture $Culture -ContentFile domainsuffix.txt
            }
            catch {
                $domPath = Resolve-LocalizedPath -Culture en -ContentFile domainsuffix.txt
            }
            $domSuffixes = $domPath | Get-CacheableContent
        }

    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        if($BaseName){
            # Remove any spaces or special characters from the provided value, then apply a random suffix from the imported list
            $hostValue = $($BaseName -replace '[^a-zA-Z]',''),$($domSuffixes | Get-Random) -join '.'
        }else {
            # If no base value was supplied, use similar options to the company generator, plus a few additional ones, to generate the domain
            $formats = $(
                '{0} {1}' -f (person any last), ($companySuffixes | Get-Random)
                '{0}-{1}' -f (person any last), (person any last)
                '{0}' -f (person any last)
                '{0}, {1} and {2}' -f (person any last), (person any last), (person any last)
                '{0} {1}' -f (noun), ($companySuffixes | Get-Random)
                '{0} {1} {2}' -f (adjective), (noun), ($companySuffixes | Get-Random)
                '{0} of {1} {2}' -f (noun), (adjective), (noun)
            )
        
            $hostValue = $($formats | Get-Random),$($domSuffixes | Get-Random) -join '.'
        }

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        # N/A as there is no AsObject option

    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        # N/A as there is no object, just single line of text

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        $hostValue

    #endregion Output
}