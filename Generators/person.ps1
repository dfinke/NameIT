function person {
    <#
    .SYNOPSIS
    The function intended to generate basic information for a person

    .DESCRIPTION
    The function generates a random name, and alternatively also the age and gender of a person. All information can be
    returned as either a simple string, or as a custom object. By default, only a simple string with the first and last 
    name is returned. 

    .PARAMETER Sex
    Provides the ability to explicitly set the gender for the returned person.

        male: Return only typical male names
        female: Return only typical female names
        any (default): Return a person with random selection of gender

    Note: The gender is primarily for selection of first name values, so supplemental genders are not accounted for.

    .PARAMETER NameParts
    Provides the ability to specify which parts of the generated person are returned.

        first: Return only the first name
        last: Return only the last name
        both (default): Return the first and last name
        full: Return the first, middle, and last name
        enhanced: Returns the full name, gender, and age

    .PARAMETER AgeBracket
    Provides the ability to specify an age range for the generated person in the event that age-related categorical data
    is required.

        Specific Ranges -
            child: Between 3 and 12
            teen: Between 13 and 19
            young adult: Between 20 and 34
            middle age: Between 35 and 61
            senior: Between 62 and 81
            elderly: Between 82 and 100
        
        General Ranges -
            any (default): Return a random age between 3 and 100
            school: Between 4 and 18
            adult: Return typical age range for working adult between 19 and 65
            retired: Between 65 and 100

    .PARAMETER AsObject
    Specifying this switch will cause a custom PSObject to be returned instead of just a simple string value, making it easier
    to reuse for other generator templates without needing to extend the functionality of this one.

    .PARAMETER Culture
    The culture used for generate - default is the current culture.

    .NOTES
    KEYWORDS: PowerShell

    VERSIONS HISTORY
    0.1.0 - 2016-01-16 - The first version published as a part of NameIT powershell module https://github.com/dfinke/NameIT
    0.1.1 - 2016-01-16 - Mistakes corrected, support for additional templates added, the paremeter Count removed
    0.1.2 - 2016-01-18 - Incorrect usage Get-Random in the templates [person*] corrected, the example corrected
    0.2.0 - 2023-03-27 - Added additional capabilities to support the new [identity] template, adjust to match other templates 
        (single generation unless called multiple times), add other possibly useful items

    The source of last names for the en-US culture - taken the first 100 on the state 2016-01-15
    http://names.mongabay.com/data/1000.html

    The source of the first names for the en-US culture - taken the first 100 on the state 2016-01-15
    http://www.behindthename.com/top/lists/united-states-decade/1980/100

    Names augmented with data from 
    https://www.familyeducation.com/baby-names/surname/origin
    https://www.back4app.com/database/back4app/list-of-names-dataset

    .EXAMPLE
    [PS] > person
    Justin Carter

    The one name returned with random sex.

    .EXAMPLE
    [PS] > 1..3 | Foreach-Object -Process { person -Sex 'female' }
    Jacqueline Walker
    Julie Richardson
    Stacey Powell

    Three names returned, only women.

    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("any", "female", "male")]
        [String]$Sex = "any",
        [Parameter()]
        [ValidateSet("first", "last", "both", "full", "enhanced")]
        [String]$NameParts = "both",
        [Parameter()]
        [ValidateSet("child","teen","young adult","adult","middle age","senior","elderly","any","school","retired")]
        [string]$AgeBracket = "any",
        [Parameter()]
        [switch]$AsObject,
        [Parameter()]
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        $femaleData = Resolve-LocalizedPath -Culture $Culture -ContentFile given-female.txt | Import-CacheableCsv -Delimiter ','
        $maleData = Resolve-LocalizedPath -Culture $Culture -ContentFile given-male.txt | Import-CacheableCsv -Delimiter ','
        $lastData = Resolve-LocalizedPath -Culture $Culture -ContentFile surnames.txt | Import-CacheableCsv -Delimiter ','

    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        # Identify which name set (male or female) to use, unless specified
        $coinGender = Get-Random -Minimum 1 -Maximum 100
        if($coinGender%2 -or $Sex -eq "female"){
            $gender = "female"
            $firstName = $femaleData | Get-Random
            $middleName = $femaleData | Get-Random
        }else {
            $gender = "male"
            $firstName = $maleData | Get-Random
            $middleName = $maleData | Get-Random
        }

        # Get the randomized last name
        $lastName = $lastData | Get-Random

        # Set the age based on the age bracket - Defaults to a typical age range for a working adult
        switch ($AgeBracket) {
            # Specific ranges
            "child" { $age = Get-Random -Minimum 3 -Maximum 12 }
            "teen" { $age = Get-Random -Minimum 13 -Maximum 19 }
            "young adult" { $age = Get-Random -Minimum 20 -Maximum 34 }
            "middle age" { $age = Get-Random -Minimum 35 -Maximum 61 }
            "senior" { $age = Get-Random -Minimum 62 -Maximum 81 }
            "elderly" { $age = Get-Random -Minimum 82 -Maximum 100 }
            # Generalized ranges
            "school" { $age = Get-Random -Minimum 4 -Maximum 18 }
            "adult" { $age = Get-Random -Minimum 19 -Maximum 65 }
            "retired" { $age = Get-Random -Minimum 65 -Maximum 100 }
            # Any
            Default { $age = Get-Random -Minimum 3 -Maximum 100 }
        }

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $output = [PSCustomObject]@{
            First = $firstName
            Middle = $middleName
            Last = $lastName
            Gender = $gender
            Age = $age
        }
    
    #endregion CreatePSObject

    #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        $dsBase = 'First', 'Last'
        $dsFirst = 'First'
        $dsLast = 'Last'
        $dsFull = 'First', 'Middle', 'Last'

        switch ($NameParts) {
            "first" { $propertyName = $dsFirst }
            "last" { $propertyName = $dsLast }
            "Full" { $propertyName = $dsFull }
            "Enhanced" { $propertyName = '*' }
            Default { $propertyName = $dsBase }
        }

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            $output | Select-Object -Property $propertyName
        }else {
            (($output | Select-Object -Property $propertyName).psobject.properties).Value -join " "
        }

    #endregion Output
}