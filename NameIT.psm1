# Inspired by
# http://mitchdenny.com/introducing-namerer-for-naming-things/

function Invoke-Generate {
    param(
        $template='????????',
        $count=1,
        [string]$alphabet='abcdefghijklmnopqrstuvwxyz',
        [string]$numbers='0123456789'
    )

    $script:alphabet = $alphabet
    $script:numbers  = $number

    $functionList = 'alpha|synonym|numeric|syllable|vowel|phoneticvowel|consonant'

    $template   = $template -replace '\?', '[alpha]' -replace '#', '[numeric]'
    $unitOfWork = $template -split "\[(.+?)\]" | ?{$_}

    1..$count | % {
        $($unitOfWork | % {
            $fn = $_.split(' ')[0]
            if($functionList.IndexOf($fn.tolower()) -eq -1) {
                $_
            } else {
                $_ | Invoke-Expression
            }
        }) -join ''
    }
}

function Get-RandomChoice {
    param($list, [int]$length=1)

    $max = $list.Length

    $(
        for ($i = 0; $i -lt $length; $i++) {
            $list[(Get-Random -Minimum 0 -Maximum $max)]
        }
    ) -join ''
}

function alpha {
    param([int]$length=1)

    Get-RandomChoice $alphabet $length
}

function numeric {
    param([int]$length=1)

    Get-RandomChoice $numbers $length
}

function synonym {
    param([string]$word)

    $url="http://words.bighugelabs.com/api/2/78ae52fd37205f0bad5f8cd349409d16/$($word)/json"

    $synonyms = $(foreach ($item in (Invoke-RestMethod $url)) {
                    $names=$item.psobject.Properties.name
                    foreach ($name in $names) {
                        $item.$name.syn -replace ' ',''
                    }
                }) | ?{$_}

    $max = $synonyms.Length
    $synonyms[(Get-Random -Minimum 0 -Maximum $max)]
}

function consonant     { Get-RandomChoice 'bcdfghjklmnpqrstvwxyz' }

function vowel         { Get-RandomChoice 'aeiou' }

function phoneticVowel {

    Get-RandomChoice 'a', 'ai', 'ay', 'au', 'aw', 'augh', 'wa', 'all', 'ald', 'alk', 'alm', 'alt',
                     'e', 'ee', 'ea', 'eu', 'ei', 'ey', 'ew', 'eigh', 'i', 'ie', 'ye', 'igh', 'ign',
                     'ind', 'o', 'oo', 'oa', 'oe', 'oi', 'oy', 'old', 'olk', 'olt', 'oll', 'ost',
                     'ou', 'ow', 'u', 'ue', 'ui'
}

function syllable {
    param([Switch]$usePhoneticVowels)

    $syllables = ((vowel) + (consonant)), ((consonant) + (vowel)), ((consonant) + (vowel) + (consonant))

    if($usePhoneticVowels) {
        $syllables += ((consonant) + (phoneticVowel))
    }

    Get-RandomChoice $syllables
}

Export-ModuleMember *-*