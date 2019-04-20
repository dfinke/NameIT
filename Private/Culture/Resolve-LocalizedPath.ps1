function Resolve-LocalizedPath {
    [CmdletBinding()]
    param(
        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture ,

        [Parameter()]
        [String]
        $CulturePath = ($ModuleBase | Join-Path -ChildPath 'cultures') ,

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
