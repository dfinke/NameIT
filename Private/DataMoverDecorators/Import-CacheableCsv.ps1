<#
.SYNOPSIS
Drop-in replacement for Import-Csv

.DESCRIPTION
Can be used transparently in most cases where Import-Csv would be used, but will store the contents in memory.
Also optionally supports transforms (your own code in a scriptblock called on each read and/or write into the cache).

#>
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
