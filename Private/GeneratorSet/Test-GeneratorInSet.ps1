function Test-GeneratorInSet {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(
            Mandatory ,
            ValueFromPipeline
        )]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [String]
        $Name
    )

    Begin {
        $local:generators = Get-GeneratorSet
    }

    Process {
        $local:generators.Contains($Name)
    }
}