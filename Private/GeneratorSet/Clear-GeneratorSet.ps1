function Clear-GeneratorSet {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    End {
        if ($Script:__generatorSet) {
            $Script:__generatorSet.Clear()
            Remove-Variable -Name __generatorSet -Scope Script -Force
        }
    }
}