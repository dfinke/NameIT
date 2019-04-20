<#
.SYNOPSIS
Drop-in replacement for Get-Content

.DESCRIPTION
Can be used transparently in most cases where Get-Content would be used, but will store the contents in memory.
Also optionally supports transforms (your own code in a scriptblock called on each read and/or write into the cache).

#>
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