function Test-GeneratorInSet {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(
            Mandatory ,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
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