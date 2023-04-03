function identity {
    <#
        .SYNOPSIS
        The function intended to generate an object with identity details
    
        .DESCRIPTION
        The function generates a random identity that can be leveraged for simulation in various apps or environments. Identity
        details are customizable to an extent, and can include first/last name, displayname, username, email, an office address/
        location, and various other data elements that might be required.
    
        .PARAMETER DataSet
        Specify the types of information to generate based on a set of collective data points
    
            Base (default): Return only first name, last name and username
            Enhanced: Returns all of the above, plus middle initial, displayname and email
            Full: Returns all attributes
    
        .PARAMETER GenPassword
        Not yet implemented: When specified, a complex password will be generated and included with the identity as part of all profiles
    
        .PARAMETER AsObject
        Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
        to reuse for other generator templates without needing to extend the functionality of this one.
    
        .PARAMETER Culture
        The culture used for generate - default is the current culture.
    
        .NOTES
        AUTHOR: Topher Whitfield
        KEYWORDS: PowerShell
    
        VERSIONS HISTORY
        0.1.0 - 2023-03-23 - The first version published as a part of forked NameIT powershell module by Doug Finke (https://github.com/dfinke/NameIT)
    
        Business title data from
        https://zety.com/blog/job-titles
        https://blog.ongig.com/job-titles
        
        .EXAMPLE
        [PS] > Invoke-Generate "[identity]"
        Justin Q Carter, carterjq092
    
        Single person identity returned, showing the displayName (first, middle initial, and last) with an Active Directory compliant username as a string

        .EXAMPLE
        [PS] > Invoke-Generate "[identity -AsObject]"

        displayName         username
        -----------         ---------
        Allexis J Pineda    pinedaaj010

        Single person identity returned, showing the displayName (first, middle initial, and last) with an Active Directory compliant username as an object

        .EXAMPLE
        [PS] > 1..3 | Foreach-Object -Process { Invoke-Generate "[identity -DataSet Enhanced -AsObject]" }

        givenName   initials    surName     userName        displayName         mail
        ---------   --------    -------     --------        ------------        ----
        Spencer     J           Bright      brightsj036     Spencer J Bright    brightsj036@barneyandsons.net
        Makena      A           Fuentes     fuentesma069    Makena A Fuentes    fuentesma069@reliefandsons.com
        Jamison     G           Day         dayjg064        Jamison G Day       jayjg064@wilsongroup.com

    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet('Base', 'Enhanced', 'Full')]
        [string]$DataSet = 'Base',
        [Parameter()]
        [switch]$GenPassword,
        [Parameter()]
        [switch]$AsObject,
        [Parameter()]
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.



    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

            # Generate an address - Generator: Person
        $person = Invoke-Generate "[person -nameParts Full -AsObject]"

        # Generate a top-level domain - Generator: Domain
        $domain = Invoke-Generate "[domain]"

        # Process CountryCode if present to determine address values - Generator: Address
        if($CountryCode){
            $address = Invoke-Generate "[address -CountryCode $CountryCode -AsObject]"
        }else {
            $address = Invoke-Generate "[address -AsObject]"
        }

        # Generate a title if one wasn't passed in - Generator: Title
        $JobTitle = Invoke-Generate "[title -AsObject]"
        
        #TODO: Create a password generator
        #TODO: Update associated generators and incorporate calls to job title, company, address, and department generators

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        # Get initials
        $gi = ($person.First)[0]
        $mi = ($person.Middle)[0]

        # Set username
        $lastName = $person.Last
        if($lastName.length -gt 8){
            $userNamePre = ($lastName).Substring(0,8).ToLower()
        }else{
            $userNamePre = ($lastName).ToLower()
        }

        $username = $userNamePre + $gi + $mi + $("{0:d3}" -f $(Get-Random -Minimum 1 -Maximum 99))

        # Process specified company, or call Company generator if no value
        $email = $username,$domain -join '@'

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $output = [PSCustomObject]@{
            givenName = $person.First
            initials = $mi
            surName = $lastName
            displayName = "$($person.First) $mi $lastName"
            mail = $email
            userName = $username
            address = $address
            title = $JobTitle.title
            department = $JobTitle.department
        }

    #endregion CreatePSObject

    
    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsBase = 'displayName','userName'
        $dsEnhanced = 'givenName','initials','surName','userName','displayName','mail'

        switch ($DataSet) {
            "Base" { $propertyName = $dsBase }
            "Enhanced" { $propertyName = $dsEnhanced }
            "Full" { $propertyName = '*' }
            Default { $propertyName = $dsBase }
        }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            $output | Select-Object -Property $propertyName
        }else {
            (($output | Select-Object -Property $propertyName).psobject.properties).Value -join ", "
        }

    #endregion Output
}