function person {
    <#
    .SYNOPSIS
    The function intended to generate string with name of a random person

    .DESCRIPTION
    The function generate a random name of females or males based on provided culture like <FirstName><Space><LastName>.
    The first and last names are randomly selected from the file delivered with for the culture

    .PARAMETER Sex
    The sex of random person.

    .PARAMETER Culture
    The culture used for generate - default is the current culture.

    .LINK
    https://www.linkedin.com/in/sciesinskiwojciech

    .NOTES
    AUTHOR: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    KEYWORDS: PowerShell

    VERSIONS HISTORY
    0.1.0 - 2016-01-16 - The first version published as a part of NameIT powershell module https://github.com/dfinke/NameIT
    0.1.1 - 2016-01-16 - Mistakes corrected, support for additional templates added, the paremeter Count removed
    0.1.2 - 2016-01-18 - Incorrect usage Get-Random in the templates [person*] corrected, the example corrected

    The future version will be developed under https://github.com/it-praktyk/New-RandomPerson

    The source of last names for the en-US culture - taken the first 100 on the state 2016-01-15
    http://names.mongabay.com/data/1000.html

    The source of the first names for the en-US culture - taken the first 100 on the state 2016-01-15
    http://www.behindthename.com/top/lists/united-states-decade/1980/100

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
        [ValidateSet("both", "female", "male")]
        [String]$Sex = "both",
        [ValidateSet("both", "first", "last")]
        [String]$NameParts = "both",
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    $AllNames = Resolve-LocalizedPath -Culture $Culture -ContentFile 'names.csv' | Import-CacheableCsv -Delimiter ','

    $AllNamesCount = $AllNames.Count

    $LastName = $AllNames[(Get-Random -Minimum 0 -Maximum $AllNamesCount)].LastName

    If ($Sex -eq 'both') {
        $RandomSex = (Get-Random @('Female', 'Male'))
        $FirstNameFieldName = "{0}FirstName" -f $RandomSex
        $FirstName = $AllNames[(Get-Random -Minimum 0 -Maximum $AllNamesCount)].$FirstNameFieldName
    }
    elseif ($Sex -eq 'female') {
        $FirstName = $AllNames[(Get-Random -Minimum 0 -Maximum $AllNamesCount)].FemaleFirstName
    }
    else {
        $FirstName = $AllNames[(Get-Random -Minimum 0 -Maximum $AllNamesCount)].MaleFirstName
    }

    switch ($NameParts) {
        "both" {"{0} {1}" -f $FirstName, $LastName}
        "first" {$FirstName}
        "last" {$LastName}
    }
}
