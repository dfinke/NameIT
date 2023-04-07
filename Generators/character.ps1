function character {
    <#
        .SYNOPSIS
        The function is intended to generate a single random character

        .DESCRIPTION
        The function generates a single random character that will be either a letter, number, or symbol. The function provides the ability to force
        return of a specific type of character set, as well as being able to specify upper or lower case when specifically returning letters.

        .PARAMETER CharType
        Enables specification of type of character class to be returned

            Any (default): A random number, symbol, or letter with random case
            Letter: Return only alpha characters
            Number: Return only number characters
            Symbol: Return only symbol characters

        .PARAMETER Case
        Enables specification of upper or lower case. 

            Upper: Return only upper case letters
            Lower: Return only lower case letters

        Note: Specifying this parameter forces only letters to be returned

        .PARAMETER ReturnSet
        Enables specification of vowels or consonants

            Vowel: Returns only vowels
            Consonant: Returns only consonants

        Note: Specifying this parameter forces only letters to be returned

        .NOTES
        KEYWORDS: PowerShell

        VERSIONS HISTORY
        0.1.0 - 2023-04-03 - New generator template

        The specific source of the ASCII codes used here is from the below link
        https://ss64.com/ascii.html

        .EXAMPLE
        [PS] > Invoke-Generator "[character]"
        
        u

        A single random character is returned, which could be a letter (upper or lower case), number, or symbol.

        .EXAMPLE
        [PS] > Invoke-Generator "[character Symbol]"
        
        *

        A single random symbol character is returned.

        .EXAMPLE
        [PS] > Invoke-Generator "[character -Case Upper -ReturnSet Vowel]"
        
        E

        A single random vowel letter character is returned in upper case.
    #>
    [CmdletBinding(DefaultParameterSetName='random')]
    Param(
        [Parameter(ParameterSetName='random',Position=0)]
        [ValidateSet('Any','Letter','Number','Symbol')]
        [string]$CharType,
        [Parameter(ParameterSetName='letter')]
        [ValidateSet('Upper','Lower')]
        [string]$Case,
        [Parameter(ParameterSetName='letter')]
        [ValidateSet('Vowel','Consonant')]
        [string]$ReturnSet
    )
    $FunctionName = $pscmdlet.MyInvocation.MyCommand.Name
    Write-Verbose "------------------- $($FunctionName): Start -------------------"

    #region DataImport
    ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
    ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

            if(($Case) -or ($ReturnSet)){
                # In the event that either Case or ReturnType is specified, only letters should be returned and CharType will be null, so we override
                $CharType = 'Letter'
            }elseif ($null -eq $CharType) {
                # If called with no values, we force a value of 'Any' so the default path is used
                $CharType = 'Any'
            }
            Write-Verbose "Generator [$FunctionName]: CharType [$CharType]"

            # ASCII character values for each range displayed in order in the preceeding comment for each set
            # Note: For letters specifically, string formatting must be forced to prevent an object from being returned that has a length of 2, and 
            # adds a trailing space that is difficult to remove
            
            # A, E, I, O, U
            $VowelUpper = 65,69,73,79,85

            # a, e, i, o, u
            $VowelLower = 97,101,105,111,117

            # B, C, D, F, G, H, J, K, L, M, N, P, Q, R, S, T, V, W, X, Y, Z
            $ConsonantUpper = 66,67,68,70,71,72,74,75,76,77,78,80,81,82,83,84,86,87,88,89,90
            
            # b, c, d, f, g, h, j, k, l, m, n, p, q, r, s, t, v, w, x, y, z
            $ConsonantLower = 98,99,100,102,103,104,106,107,108,109,110,112,113,114,115,116,118,119,120,121,122

            switch ($CharType) {
                'Letter' {
                    Write-Verbose "Generator [$FunctionName]: CharType [$CharType]: Case [$Case]"
                    Write-Verbose "Generator [$FunctionName]: CharType [$CharType]: ReturnSet [$ReturnSet]"

                    switch ($Case) {
                        'Upper' {
                            # Case - Upper: check for a ReturnSet value and provide either the range, or min and max values
                            switch ($ReturnSet) {
                                'Vowel' { $Range = $VowelUpper } # Return vowels in upper case only
                                'Consonant' { $Range = $ConsonantUpper } # Return consonants in upper case only
                                Default { $Min = 65; $Max = 69} # If neither Vowel nor Consonant, then return any upper case letter
                            }
                        }
                
                        'Lower' { 
                            # Case - Lower: check for a ReturnSet value and provide either the range, or min and max values
                            switch ($ReturnSet) {
                                'Vowel' { $Range = $VowelLower } # Return vowels in lower case only
                                'Consonant' { $Range = $ConsonantLower } # Return consonants in lower case only
                                Default { $Min = 97; $Max = 122} # If neither Vowel nor Consonant, then return any lower case letter
                            }
                        }
                
                        Default {
                            # If Case is not specified, flip a virtual coin to determine upper or lower, since ranges are not contiguous
                            $coinCase = Get-Random -Minimum 1 -Maximum 100

                            switch ($ReturnSet) {
                                'Vowel' { 
                                    if($coinCase%2){
                                        $Range = $VowelUpper
                                    }else {
                                        $Range = $VowelLower
                                    }
                                } # If ReturnSet is 'Vowel', return either upper or lower case Vowels based on coin flip

                                'Consonant' {
                                    if($coinCase%2){
                                        $Range = $ConsonantUpper
                                    }else {
                                        $Range = $ConsonantLower
                                    }
                                } # If ReturnSet is 'Consonant', return either upper or lower case Consonants based on coin flip

                                Default {
                                    if($coinCase%2){
                                        $Min = 65
                                        $Max = 90
                                    }else {
                                        $Min = 97
                                        $Max = 122
                                    }
                                } # If ReturnSet isn't specified, then use the coin flip to return the entire range of letters in either upper or lower
                            }        
                        }
                    }

                    # Determine if we are processing a range value set, or specific minimum and maximum values, then get the value for output; Force output to be in string format
                    # Note: While these ranges are small, specifying min/max is faster for larger data sets, as otherwise the entire pipeline of values has to go through Get-Random first 
                    # before a value is selected
                    if($Range){
                        [string]$output = "$([char]$($Range | Get-Random))"
                    }else {
                        [string]$output = "$([char]$(Get-Random -Minimum $Min -Maximum $Max))"
                    }

                } # End of CharType = Letter

                'Number' {
                    # Use the ASCII range values from 0 - 9; Force output to be in string format
                    [string]$output = "$([char]$(Get-Random -Minimum 48 -Maximum 57))"
                } # End of CharType = Number

                'Symbol' {
                    # Randomly determine which set of ASCII ranges of symbols to select from
                    $group = Get-Random -Minimum 1 -Maximum 4

                    # Symbols associated with each group are shown in order of assent in the associated comment; Force output to be in string format
                    switch ($group) {
                        1 { [string]$output = "$([char]$(Get-Random -Minimum 33 -Maximum 47))" } # Includes !, ", #, $, %, &, ', (, ), *, +, comma, -, ., /
                        2 { [string]$output = "$([char]$(Get-Random -Minimum 58 -Maximum 64))" } # Includes :, ;, <, =, >, ?. @
                        3 { [string]$output = "$([char]$(Get-Random -Minimum 91 -Maximum 95))" } # Includes [, \, ], ^, _
                        4 { [string]$output = "$([char]$(Get-Random -Minimum 123 -Maximum 126))" } #Includes {, |, }, ~
                    }
                }

                Default {
                    # If no values specified, or if CharType is set to 'Any', return any valid value in the range; Use preceeding comments, or review Notes link, to determine values; Force output to be in string format
                    # Note: The below may result in return of the back tick character (`) which serves as an escape character for PowerShell
                    [string]$output = "$([char]$(Get-Random -Minimum 33 -Maximum 126))"
                }
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

        # N/A as there are no data sets to process

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        $output

    #endregion Output
    Write-Verbose "------------------- $($FunctionName): End -------------------"
}