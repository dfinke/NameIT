<#
.Synopsis
   Utilize Invoke-Generate to create a random value type

.DESCRIPTION
   NameIt returns strings including unecessary zeros in numbers. Get-RandomValue returns a specified values type.

.PARAMETER Template
   A Nameit template string.

   [alpha]; selects a random character (constrained by the -Alphabet parameter).
   [numeric]; selects a random numeric (constrained by the -Numbers parameter).
   [vowel]; selects a vowel from a, e, i, o or u.
   [phoneticVowel]; selects a vowel sound, for example ou.
   [consonant]; selects a consonant from the entire alphabet.
   [syllable]; generates (usually) a pronouncable single syllable.
   [synonym word]; finds a synonym to match the provided word.
   [person]; generate random name of female or male based on provided culture like <FirstName><Space><LastName>.
   [person female]; generate random name of female based on provided culture like <FirstName><Space><LastName>.
   [person male]; generate random name of male based on provided culture like <FirstName><Space><LastName>.
   [address]; generate a random street address. Formatting is biased to US currently.
   [space]; inserts a literal space. Spaces are striped from the templates string by default.

.PARAMETER Count
   The number of random items to return.

.PARAMETER Alphabet
   A set of alpha characters used to generate random strings.

.PARAMETER Numbers
   A set of digit characters used to generate random numerics.

.EXAMPLE
   PS C:\> Invoke-Generate
   lhcqalmf

.EXAMPLE
   PS C:\> Invoke-Generate -alphabet abc
   cabccbca

.EXAMPLE
   PS C:\> Invoke-Generate "cafe###"
   cafe176

.EXAMPLE
   PS C:\> Invoke-Generate "???###"
   yhj561

.EXAMPLE
   PS C:\> Invoke-Generate -count 5 "[synonym cafe]_[syllable][syllable]"
   restaurant_owkub
   coffeebar_otqo
   eatingplace_umit
   coffeeshop_fexuz
   coffeebar_zuvpe

.Notes
   Inspired by
   http://mitchdenny.com/introducing-namerer-for-naming-things/
#>

$ApprovedVerb=$false

function Invoke-Generate {
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [String]
        $Template = '????????',

        [Parameter(Position=1)]
        [int]
        $Count = 1,

        [Parameter(Position=2)]
        [string]
        $Alphabet = 'abcdefghijklmnopqrstuvwxyz',

        [Parameter(Position=3)]
        [string]
        $Numbers = '0123456789',

        [Parameter(Position=4)]
        [HashTable]$CustomData,

        [Switch]$ApprovedVerb,
        [Switch]$AsTabDelimited,
        [Switch]$AsPSObject,
        [Switch]$IncludeTimeStamp
    )

    $script:alphabet = $alphabet
    $script:numbers = $number

    $functionList = 'alpha|synonym|numeric|syllable|vowel|phoneticvowel|consonant|person|address|space|noun|adjective|verb|cmdlet|state|dave|guid|timeStamp'.Split('|')

    $customDataFile="$PSScriptRoot\customData\customData.ps1"
    if(Test-Path $customDataFile){
        $CustomData+=. $customDataFile
    }

    if($CustomData) {
        foreach ($key in $CustomData.Keys) {
            $functionList+=$key
            "function $key { echo $($CustomData.$key) | Get-Random }" | Invoke-Expression
        }
    }

    $functionList=$functionList.ToLower()

    $template = $template -replace '\?', '[alpha]' -replace '#', '[numeric]'
    $unitOfWork = $template -split "\[(.+?)\]" | Where-Object -FilterScript { $_ }
    $ApprovedVerb=$ApprovedVerb

    1..$count | ForEach-Object -Process {
        $r=$($unitOfWork | ForEach-Object -Process  {
            $fn = $_.split(' ')[0]
            if ($functionList -notcontains $fn) {
                $_
            }
            else {
                $_ | Invoke-Expression
            }
        }) -join ''

        if($AsPSObject) {
            [pscustomobject](ConvertFrom-StringData $r)
        } elseif($AsTabDelimited) {
            [pscustomobject](ConvertFrom-StringData $r) |
            ConvertTo-Csv -Delimiter "`t" -NoTypeInformation
        } else {
            $r
        }
    }
}

<#
.Synopsis
   Utilize Invoke-Generate to create a random value with a specified type.

.DESCRIPTION
   NameIt returns strings including unecessary zeros in numbers. Get-RandomValue returns a specified values type.

.PARAMETER Template
   A Nameit template string.

.PARAMETER As
   A type name specifying the return type of the command.

.PARAMETER Alphabet
   A set of alpha characters used to generate random strings.

.PARAMETER Numbers
   A set of digit characters used to generate random numerics.

.EXAMPLE
   PS C:\> 1..3 | % {Get-RandomValue "###.##" -as double}
   75.41
   439.92
   195.55

.EXAMPLE
   PS C:\> 1..3 | % {Get-RandomValue "#.#.#" -as version}

   Major  Minor  Build  Revision
   -----  -----  -----  --------
   1      3      1      -1
   2      2      5      -1
   7      1      0      -1
#>
function Get-RandomValue {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory,Position=0)]
        [string]
        $Template,

        [Parameter(Position=1)]
        [Type]
        $As,

        [Parameter(Position=2)]
        [string]
        $Alphabet,

        [Parameter(Position=3)]
        [string]
        $Numbers
    )

    $type = $null

    if ( $PSBoundParameters.ContainsKey('As') ) {

        $type = $As

    }

    $null = $PSBoundParameters.Remove('As')
    $stringValue = Invoke-Generate @PSBoundParameters

    if ( -not $null -eq $type ) {

        $returnValue = $stringValue -as $type
        if ($null -eq $returnValue) {

            Write-Warning "Could not cast '$stringValue' to [$($type.Name)]"

        }

    }
    else {

        $returnValue = $stringValue

    }

    $returnValue
}

function Get-RandomChoice {
    param (
        $list,
        [int]$length = 1
    )

    $max = $list.Length

    $(
    for ($i = 0; $i -lt $length; $i++) {
        $list[(Get-Random -Minimum 0 -Maximum $max)]
    }
) -join ''
}

$nouns=Get-Content -Path "$PSScriptRoot\cultures\en-US.nouns.txt"
$adjectives=Get-Content -Path "$PSScriptRoot\cultures\en-US.adjectives.txt"
$verbs=Get-Content -Path "$PSScriptRoot\cultures\en-US.verbs.txt"

function noun {
    $nouns | Get-Random
}

function adjective {
    $adjectives | Get-Random
}

function verb {
    $verbs | Get-Random
}

function baseVerbNoun {
    if($ApprovedVerb) {
        $verb = (Get-Verb | Get-Random).verb
    } else {
        $verb = (verb)
    }

    "{0}-{1}" -f $verb,(noun)
}

function cmdlet {
    baseVerbNoun
}

function address {
    Param
    (
        [String]$Culture = "en-US"
    )

    $numberLength = Get-Random -Minimum 3 -Maximum 6
    $streetLenth = Get-Random -Minimum 2 -Maximum 6

    $houseNumber = Get-RandomValue -Template "[numeric $numberLength]" -As int

    $streetTemplate = "[syllable]" * $streetLenth
    $street = Invoke-Generate $streetTemplate

    $suffix = Get-Content -Path "$PSScriptRoot\cultures\$Culture.streetsuffix.txt" | Get-Random

    $address = $houseNumber,$street,$suffix -join ' '

    (culture).TextInfo.ToTitleCase($address)
}

function space {
    param (
        [int]$length = 1
    )
    ' ' * $length
}

function alpha {
    param ([int]$length = 1)

    Get-RandomChoice $alphabet $length
}

function numeric {
    param ([int]$length = 1)

    (Get-RandomChoice $numbers $length) -as [int]
}

function synonym {
    param ([string]$word)

    $url = "http://words.bighugelabs.com/api/2/78ae52fd37205f0bad5f8cd349409d16/$($word)/json"

    $synonyms = $(foreach ($item in (Invoke-RestMethod $url)) {
        $names = $item.psobject.Properties.name
        foreach ($name in $names) {
            $item.$name.syn -replace ' ', ''
        }
    }) | Where-Object -FilterScript { $_ }

$max = $synonyms.Length
$synonyms[(Get-Random -Minimum 0 -Maximum $max)]
}

function consonant {
    Get-RandomChoice 'bcdfghjklmnpqrstvwxyz' 
}

function vowel {
    Get-RandomChoice 'aeiou' 
}

function phoneticVowel {

    Get-RandomChoice 'a', 'ai', 'ay', 'au', 'aw', 'augh', 'wa', 'all', 'ald', 'alk', 'alm', 'alt',
    'e', 'ee', 'ea', 'eu', 'ei', 'ey', 'ew', 'eigh', 'i', 'ie', 'ye', 'igh', 'ign',
    'ind', 'o', 'oo', 'oa', 'oe', 'oi', 'oy', 'old', 'olk', 'olt', 'oll', 'ost',
    'ou', 'ow', 'u', 'ue', 'ui'
}

function syllable {
    param ([Switch]$usePhoneticVowels)

    $syllables = ((vowel) + (consonant)), ((consonant) + (vowel)), ((consonant) + (vowel) + (consonant))

    if ($usePhoneticVowels) {
        $syllables += ((consonant) + (phoneticVowel))
    }

    Get-RandomChoice $syllables
}

function person {
    <#
    .SYNOPSIS
    The function intended to generate string with name of a random person

    .DESCRIPTION
    The function generate a random name of females or mailes based on provided culture like <FirstName><Space><LastName>.
    The first and last names are randomly selected from the file delivered with  for the culture

    .PARAMETER Sex
    The sex of random person.

    .PARAMETER Culture
    The culture used for generate - default is en-US.

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
    param (
        [parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("both", "female", "male")]
        [String]$Sex = "both",
        [String]$Culture = "en-US"
    )

    $ModulePath = Split-Path $script:MyInvocation.MyCommand.Path

    [String]$CultureFileName = "{0}\cultures\{1}.csv" -f $ModulePath, $Culture

    $AllNames = Import-Csv -Path $CultureFileName -Delimiter ","

    $AllNamesCount = ($AllNames | Measure-Object).Count

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

    Return $([String]"{0} {1}" -f $FirstName, $LastName)

}

function State {
    param(
        $property="name",
        [String]$Culture = "en-US"
    )

    $CultureFileName = "$($PSScriptRoot)\cultures\{0}.States.csv" -f  $Culture
    $states=Import-Csv $CultureFileName

    switch($property) {
        "name"    {
            $property="statename"
        }
        "abbr"    {
            $property="abbreviation"
        }
        "capital" {
            $property="capital"
        }
        "zip" {
            $property="zip"
        }
        "all" {
            $targetState=$states | Get-Random
            "{0},{1},{2},{3}" -f $targetState.Capital,$targetState.StateName,$targetState.Abbreviation,$targetState.Zip
        }
        default {
            throw "property [$($property)] not supported"
        }
    }

    $states | get-random | % $property
}

# Too Many Daves by Dr. Seuss
# https://www.poetryfoundation.org/poems-and-poets/poems/detail/42882
function Dave {
    param(
        [String]$Culture = "en-US"
    )

    $CultureFileName = "$($PSScriptRoot)\cultures\{0}.daves.txt" -f  $Culture
    $daves=Get-Content $CultureFileName

    $daves | get-random
}

function guid {
    param(
        $part
    )

    $guid=[guid]::NewGuid().guid

    if($part -ne $null) {
        ($guid -split '-')[$part]
    } else {
        $guid
    }
}

function timeStamp {    
    param($format="MMdd-HHmm")
    ((Get-Date).ToUniversalTime()).ToString($format)
}

Set-Alias ig Invoke-Generate

Export-ModuleMember -Function Invoke-Generate -Alias ig