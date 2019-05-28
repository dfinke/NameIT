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
        [String]$CustomDataFile = "$ModuleBase\customData\customData.ps1",

        [Switch]$ApprovedVerb,
        [Switch]$AsCsv,
        [Switch]$UseCsvCultureSeparator,
        [Switch]$AsTabDelimited,
        [Switch]$AsPSObject ,

        [Parameter()]
        [int]
        $SetSeed ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    if ($PSBoundParameters.ContainsKey('SetSeed')) {
        $null = Get-Random -SetSeed $SetSeed
    } 

    $script:alphabet = $alphabet
    $script:numbers = $number

    if (Test-Path $CustomDataFile) {
        $CustomData += . $CustomDataFile
    }

    if ($CustomData) {
        foreach ($key in $CustomData.Keys) {
            Add-GeneratorToSet -Name $key
            $null = New-Item -Path Function: -Name $key -Value { $CustomData[$MyInvocation.InvocationName] | Get-Random } -Force
        }
    }

    $template = $template -replace '\?', '[alpha]' -replace '#', '[numeric]'
    $unitOfWork = $template -split "\[(.+?)\]" | Where-Object -FilterScript { $_ }
    $tokenizerErrors = $null # must be declared for [ref]

    1..$count | ForEach-Object -Process {
        $r = -join $($unitOfWork | ForEach-Object -Process {
                $tokens = [System.Management.Automation.PSParser]::Tokenize($_, [ref] $tokenizerErrors)
                $fn = $tokens[0].Content
                if (Test-GeneratorInSet -Name $fn) {
                    $generator = Get-Command -Name $fn -ErrorAction Stop
                    $arguments = $tokens | 
                        Select-Object -Skip 1 |
                        ForEach-Object -Process {
                            if ($_.Type -eq [System.Management.Automation.PSTokenType]::String) {
                                "'{0}'" -f [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($_.Content)
                            } else {
                                $_.Content
                            }
                        }

                    if ($generator.Parameters.ContainsKey('Culture') -and $arguments.Count -le $generator.Parameters['Culture'].Attributes.Position) {
                        $arguments = @() + $arguments + @('-Culture', $Culture.ToString())
                    }

                    $generatorExpression = "$fn $arguments"
                    $generatorExpression | Write-Verbose
                    $generatorExpression | Invoke-Expression
                } else {
                    $_
                }
            })

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
