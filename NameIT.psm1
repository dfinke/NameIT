# Inspired by
# http://mitchdenny.com/introducing-namerer-for-naming-things/

function Invoke-Generate {
    param (
        $template = '????????',
        $count = 1,
        [string]$alphabet = 'abcdefghijklmnopqrstuvwxyz',
        [string]$numbers = '0123456789'
    )

    $script:alphabet = $alphabet
    $script:numbers = $number

    $functionList = 'alpha|synonym|numeric|syllable|vowel|phoneticvowel|consonant|person|space'

    $template = $template -replace '\?', '[alpha]' -replace '#', '[numeric]' -replace ' ', '[space]'
    $unitOfWork = $template -split "\[(.+?)\]" | Where-Object -FilterScript { $_ }

    1..$count | ForEach-Object -Process {
        $($unitOfWork | ForEach-Object -Process  {
            $fn = $_.split(' ')[0]
            if ($functionList.IndexOf($fn.tolower()) -eq -1) {
                $_
            }
            else {
                $_ | Invoke-Expression
            }
        }) -join ''
    }
}

function Get-RandomChoice {
    param ($list,
        [int]$length = 1)

    $max = $list.Length

    $(
    for ($i = 0; $i -lt $length; $i++) {
        $list[(Get-Random -Minimum 0 -Maximum $max)]
    }
    ) -join ''
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

    Get-RandomChoice $numbers $length
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

function consonant { Get-RandomChoice 'bcdfghjklmnpqrstvwxyz' }

function vowel { Get-RandomChoice 'aeiou' }

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

Export-ModuleMember *