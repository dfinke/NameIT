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
