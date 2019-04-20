. $PSScriptRoot\InferData.ps1

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
   [person female first]
   [person female last]
   [person male]; generate random name of male based on provided culture like <FirstName><Space><LastName>.
   [person male first]
   [person male last]
   [person both first]
   [person both last]
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

$ApprovedVerb = $false

function Invoke-Generate {
    [CmdletBinding(DefaultParameterSetName = "Data")]
    param (
        [Parameter(Position = 0)]
        [String]
        $Template = '????????',

        [Parameter(Position = 1)]
        [int]
        $Count = 1,

        [Parameter(Position = 2)]
        [string]
        $Alphabet = 'abcdefghijklmnopqrstuvwxyz',

        [Parameter(Position = 3)]
        [string]
        $Numbers = '0123456789',

        [Parameter(Position = 4)]
        [HashTable]$CustomData,

        [Parameter(Position = 5)]
        [String]$CustomDataFile,

        [Switch]$ApprovedVerb,
        [Switch]$AsCsv,
        [Switch]$UseCsvCultureSeparator,
        [Switch]$AsTabDelimited,
        [Switch]$AsPSObject ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    $script:alphabet = $alphabet
    $script:numbers = $number

    $functionList = @(
         'alpha'
        ,'synonym'
        ,'numeric'
        ,'syllable'
        ,'vowel',
        ,'phoneticvowel'
        ,'consonant'
        ,'person'
        ,'address'
        ,'space'
        ,'noun'
        ,'adjective'
        ,'verb'
        ,'cmdlet'
        ,'state'
        ,'dave'
        ,'guid'
        ,'randomdate'
        ,'fortnite'
        ,'color'
    )

    if (-not $PSBoundParameters.ContainsKey("CustomDataFile")) {
        $customDataFile = "$PSScriptRoot\customData\customData.ps1"
    }

    if (Test-Path $customDataFile) {
        $CustomData += . $customDataFile
    }

    if ($CustomData) {
        foreach ($key in $CustomData.Keys) {
            $functionList += $key
            "function $key { `$CustomData.$key | Get-Random }" | Invoke-Expression
        }
    }

    $functionList = $functionList.ToLower()

    $template = $template -replace '\?', '[alpha]' -replace '#', '[numeric]'
    $unitOfWork = $template -split "\[(.+?)\]" | Where-Object -FilterScript { $_ }
    $ApprovedVerb = $ApprovedVerb

    1..$count | ForEach-Object -Process {
        $r = $($unitOfWork | ForEach-Object -Process {
                $fn = ($_ -split '\s+')[0]
                if ($functionList -notcontains $fn) {
                    $_
                }
                else {
                    $_ | Invoke-Expression
                }
            }) -join ''

        if ($AsPSObject) {
            [pscustomobject](ConvertFrom-StringData $r)
        }
        elseif ($AsCsv) {
            $separator = if ($UseCsvCultureSeparator) {
                @{
                    Delimiter = $Culture.TextInfo.ListSeparator
                }
            } else {
                @{}
            }
            [pscustomobject](ConvertFrom-StringData $r) |
                ConvertTo-Csv -NoTypeInformation @separator
        }
        elseif ($AsTabDelimited) {
            [pscustomobject](ConvertFrom-StringData $r) |
                ConvertTo-Csv -Delimiter "`t" -NoTypeInformation
        }
        else {
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
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Template,

        [Parameter(Position = 1)]
        [Type]
        $As,

        [Parameter(Position = 2)]
        [string]
        $Alphabet,

        [Parameter(Position = 3)]
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

function Resolve-LocalizedPath {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture ,

        [Parameter()]
        [String]
        $CulturePath = ($PSScriptRoot | Join-Path -ChildPath 'cultures') ,

        [Parameter()]
        [cultureinfo]
        $FallbackCulture = 'en' ,

        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [String]
        $ContentFile ,

        [Parameter()]
        [Switch]
        $StrictCultureMatch ,

        [Parameter()]
        [Switch]
        $StrictLanguageMatch
    )

    Begin {
        $StrictLanguageMatch = $StrictLanguageMatch -or $StrictCultureMatch

        $LanguageFilePath = $CulturePath | Join-Path -ChildPath $Culture.TwoLetterISOLanguageName

        if (-not ($LanguageFilePath | Test-Path)) {
            if ($StrictLanguageMatch) {
                throw [System.Globalization.CultureNotFoundException]"No cultures with languages compatible with '$($Culture.EnglishName)' were found."
            } else {
                $Culture = $FallbackCulture
                $LanguageFilePath = $CulturePath | Join-Path -ChildPath $Culture.TwoLetterISOLanguageName

                Write-Verbose -Message "Falling back to culture '$($Culture.EnglishName)'"
            }
        }

        $CultureCode = $Culture.Name.Split('-')[1]

        if ($CultureCode)  {
            $CultureFilePath = $LanguageFilePath | Join-Path -ChildPath $CultureCode
            $UseSpecificCulture = $CultureFilePath | Test-Path

            if ($StrictCultureMatch -and -not $UseSpecificCulture) {
                throw [System.Globalization.CultureNotFoundException]"No cultures matching '$($Culture.EnglishName) ($($Culture.Name))' were found."
            }
        }
    }
    
    Process {
        if ($UseSpecificCulture) {
            $ContentPath = $CultureFilePath | Join-Path -ChildPath $ContentFile

            if (($ContentPath | Test-Path)) {
                return $ContentPath | Resolve-Path
            } elseif ($StrictCultureMatch) {
                throw [System.IO.FileNotFoundException]"The content file '$ContentFile' does not exist for culture '$($Culture.EnglishName)'"
            }
        }

        $ContentPath = $LanguageFilePath | Join-Path -ChildPath $ContentFile
        if (($ContentPath | Test-Path)) {
            return $ContentPath | Resolve-Path
        } else {
            throw [System.IO.FileNotFoundException]"The content file '$ContentFile' does not exist for culture '$($Culture.EnglishName)'"
        }
    }
}

function Get-CacheStore {
    [CmdletBinding()]
    param()

    End {
        if (-not $Script:__cache) {
            Set-Variable -Name __cache -Scope Script -Value ([System.Collections.Generic.Dictionary[string,object]]::new()) -Option ReadOnly,AllScope
        }

        $Script:__cache
    }
}

function Clear-CacheStore {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $Key
    )

    $local:cache = Get-CacheStore

    if ($key) {
        $null = $local:cache.Remove($key)
    } else {
        $local:cache.Clear()
    }
}
function Get-CacheableContent {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(
            ParameterSetName = 'Path' ,
            Mandatory ,
            ValueFromPipelineByPropertyName
        )]
        [String[]]
        $Path ,

        [Parameter(
            ParameterSetName = 'LiteralPath' ,
            Mandatory ,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [String[]]
        $LiteralPath ,

        [Parameter()]
        [Object] # in core this is [System.Text.Encoding], in desktop it's [FileSystemCmdletProviderEncoding]
        $Encoding = 'utf8' ,

        [Parameter()]
        [Switch]
        $Raw ,

        [Parameter()]
        [Switch]
        $RefreshCache ,

        [Parameter()]
        [Alias('Process')]
        [ScriptBlock]
        $Transform ,

        [Parameter()]
        [ValidateSet(
             'Read'
            ,'Write'
            ,'ReadWrite'
        )]
        [String]
        $TransformCacheContentOn = 'Write'
    )

    Begin {
        $local:cache = Get-CacheStore

        $commonParams = @{}
        if ($Encoding) {
            $commonParams.Encoding = $Encoding
        }

        if ($Raw) {
            $commonParams.Raw = $Raw
        }
    }

    Process {
        $OnePath = $PSBoundParameters[$PSCmdlet.ParameterSetName]

        foreach ($thisPath in $OnePath) {
            $key = $thisPath

            if ($RefreshCache -or -not $local:cache.ContainsKey($key)) {
                $params = $commonParams.Clone()
                $params[$PSCmdlet.ParameterSetName] = $thisPath

                $content = Get-Content @params

                $local:cache[$key] = if ($Transform -and $TransformCacheContentOn -in 'Write','ReadWrite') {
                    $content | ForEach-Object -Process $Transform
                } else {
                    $content
                }
            }
            
            if ($Transform -and $TransformCacheContentOn -in 'Read','ReadWrite') {
                $local:cache[$key] | ForEach-Object -Process $Transform
            } else {
                $local:cache[$key]
            }
        }
    }
}
function Import-CacheableCsv {
    [CmdletBinding(DefaultParameterSetName = 'Delimiter')]
    param(
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path ,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [String[]]
        $LiteralPath ,

        [Parameter(
            ParameterSetName = 'Delimiter'
        )]
        [char]
        $Delimiter ,

        [Parameter()]
        [object]
        $Encoding = 'utf8' ,

        [Parameter()]
        [String[]]
        $Header ,

        [Parameter(
            ParameterSetName = 'UseCulture' ,
            Mandatory
        )]
        [Switch]
        $UseCulture ,

        [Parameter(
            ParameterSetName = 'UseCulture'
        )]
        [cultureinfo]
        $Culture ,

        [Parameter()]
        [Switch]
        $RefreshCache ,

        [Parameter()]
        [Alias('Process')]
        [ScriptBlock]
        $Transform ,

        [Parameter()]
        [ValidateSet(
             'Read'
            ,'Write'
            ,'ReadWrite'
        )]
        [String]
        $TransformCacheContentOn = 'Write'
    )

    Begin {
        $local:cache = Get-CacheStore

        $commonParams = @{}
        if ($Encoding) {
            $commonParams.Encoding = $Encoding
        }

        if ($Delimiter) {
            $commonParams.Delimiter = $Delimiter
        }

        if ($Header) {
            $commonParams.Header = $Header
        }

        if ($UseCulture) {
            if ($Culture) {
                $commonParams.Delimiter = $Culture.TextInfo.ListSeparator
            } else {
                $commonParams.UseCulture = $UseCulture
            }
        }
    }

    Process {
        $params = $commonParams.Clone()

        if ($PSBoundParameters.ContainsKey('LiteralPath')) {
            $OnePath = $LiteralPath
            $pathParam = 'LiteralPath'
        }

        if ($PSBoundParameters.ContainsKey('Path')) {
            if ($OnePath) {
                throw [System.InvalidOperationException]'You must specify either the -Path or -LiteralPath parameters, but not both.'
            }
            $OnePath = $Path
            $pathParam = 'Path'
        }

        foreach ($thisPath in $OnePath) {
            $key = $thisPath

            if ($RefreshCache -or -not $local:cache.ContainsKey($key)) {
                $params[$pathParam] = $thisPath

                $content = Import-Csv @params

                $local:cache[$key] = if ($Transform -and $TransformCacheContentOn -in 'Write','ReadWrite') {
                    $content | ForEach-Object -Process $Transform
                } else {
                    $content
                }
            }
            
            if ($Transform -and $TransformCacheContentOn -in 'Read','ReadWrite') {
                $local:cache[$key] | ForEach-Object -Process $Transform
            } else {
                $local:cache[$key]
            }
        }
    }
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

function noun {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'nouns.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}

function adjective {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'adjectives.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}

function verb {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'verbs.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}

function color {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -ContentFile 'colors.txt' -Culture $Culture | Get-CacheableContent | Get-Random
}

function baseVerbNoun {
    if ($ApprovedVerb) {
        $verb = (Get-Verb | Get-Random).verb
    }
    else {
        $verb = (verb)
    }

    "{0}-{1}" -f $verb, (noun)
}

function cmdlet {
    baseVerbNoun
}

function address {
    [CmdletBinding()]
    param (
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    $numberLength = Get-Random -Minimum 3 -Maximum 6
    $streetLength = Get-Random -Minimum 2 -Maximum 6

    $houseNumber = Get-RandomValue -Template "[numeric $numberLength]" -As int

    $streetTemplate = "[syllable]" * $streetLength
    $street = Invoke-Generate $streetTemplate

    $suffix = Resolve-LocalizedPath -Culture $Culture -ContentFile 'streetsuffix.txt' | Get-CacheableContent | Get-Random

    $address = $houseNumber, $street, $suffix -join ' '

    $Culture.TextInfo.ToTitleCase($address)
}

function space {
    [CmdletBinding()]
    param(
        [Parameter()]
        [uint32]
        $Length = 1 ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    Resolve-LocalizedPath -Culture $Culture -ContentFile 'space.txt' | 
        Get-CacheableContent -Raw -Transform { $_ * $Length } -TransformCacheContentOn Read
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

    $AllNames = Resolve-LocalizedPath -Culture $Culture -ContentFile 'names.csv' | Import-CacheableCsv -UseCulture -Culture $Culture

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

function State {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $property = "name",

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    $states = Resolve-LocalizedPath -Culture $Culture -ContentFile 'states.csv' | Import-CacheableCsv -UseCulture -Culture $Culture

    switch ($property) {
        "name" {$property = "statename"}
        "abbr" {$property = "abbreviation"}
        "capital" {$property = "capital"}
        "zip" {$property = "zip"}
        "all" {
            $targetState = $states | Get-Random
            "{0},{1},{2},{3}" -f $targetState.Capital, $targetState.StateName, $targetState.Abbreviation, $targetState.Zip
        }
        default { throw "property [$($property)] not supported"}
    }

    $states | Get-Random | % $property
}

# Too Many Daves by Dr. Seuss
# https://www.poetryfoundation.org/poems-and-poets/poems/detail/42882
function Dave {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )
    Resolve-LocalizedPath -Culture $Culture -ContentFile 'daves.txt' | Get-CacheableContent | Get-Random
}

function guid {
    [CmdletBinding()]
    param(
        [Parameter()]
        [int]
        $part
    )

    $guid = [guid]::NewGuid().guid

    if ($part) {
        ($guid -split '-')[$part]
    } else {
        $guid
    }
}

function RandomDate {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias('TheMin')]
        [DateTime]
        $MinDate = [DateTime]::MinValue,

        [Parameter()]
        [Alias('TheMax')]
        [DateTime]
        $MaxDate = [DateTime]::MaxValue ,

        [Parameter()]
        [String]
        $Format ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    if (-not $Format) {
        $Format = $Culture.DateTimeFormat.ShortDatePattern
    }

    $theRandomGen = New-Object random
    $theRandomTicks = [Convert]::ToInt64( ($MaxDate.ticks * 1.0 - $MinDate.Ticks * 1.0 ) * $theRandomGen.NextDouble() + $MinDate.Ticks * 1.0 )

    (New-Object DateTime $theRandomTicks).ToString($Format, $Culture.DateTimeFormat)
}

function Fortnite {
    param (
        [Parameter(Position = 0)]
        [char]
        $Char
    )

    $Filter = { 
        if ($_ -like "$Char*") {
            $_
        }
    }

    $adj = Resolve-LocalizedPath -ContentFile 'adjectives.txt' | 
        Get-CacheableContent -Transform $Filter -TransformCacheContentOn Read |
        Get-Random

    $Char = $adj[0]

    $noun = Resolve-LocalizedPath -ContentFile 'nouns.txt' | 
        Get-CacheableContent -Transform $Filter -TransformCacheContentOn Read |
        Get-Random

    "$adj" + $noun
}

function cvtDataTypeToNameIt {
    param($dataType)

    switch ($dataType) {
        "int" {"numeric 5"}
        "string" {"alpha 6"}
        default {"alpha 6"}
    }
}

function New-NameItTemplate {
<#
    .SYNOPSIS
    Auto gen a template

    .EXAMPLE
    ig (New-NameItTemplate {[PSCustomObject]@{Company="";Name="";Age=0;address="";state="";zip=""}}) -Count 5 -AsPSObject | ft
#>
    param(
        [scriptblock]$sb
    )

    $result = &$sb
    $result.psobject.properties.name.foreach( {
            $propertyName = $_

            switch ($propertyName) {
                "name"    {"$($propertyName)=[person]"}
                "zip"     {"$($propertyName)=[state zip]"}
                "address" {"$($propertyName)=[address]"}
                "state"   {"$($propertyName)=[state]"}
                default   {
                    $dataType = Invoke-AllTests $result.$propertyName -OnlyPassing -FirstOne
                    "{0}=[{1}]" -f $propertyName, (cvtDataTypeToNameIt $dataType.dataType)
                }
            }
        }) -join "`r`n"
}

Set-Alias ig Invoke-Generate

Export-ModuleMember -Function * -Alias *