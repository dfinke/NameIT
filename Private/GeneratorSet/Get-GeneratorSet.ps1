function Get-GeneratorSet {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[string]])]
    param(
        [Parameter()]
        [System.Collections.Generic.IEqualityComparer[string]]
        $Comparer = [System.StringComparer]::InvariantCultureIgnoreCase ,

        [Parameter()]
        [Switch]
        $Enumerate
    )

    End {
        if (-not $Script:__generatorSet) {
            Set-Variable -Name __generatorSet -Scope Script -Value (
                [System.Collections.Generic.HashSet[string]]::new([string[]]$MyInvocation.MyCommand.Module.PrivateData.GeneratorList, $Comparer)
            ) -Option ReadOnly,AllScope
        }

        Write-Output -InputObject $Script:__generatorSet -NoEnumerate:(-not $Enumerate)
    }
}
