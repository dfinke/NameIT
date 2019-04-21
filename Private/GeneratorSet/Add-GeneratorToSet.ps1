function Add-GeneratorToSet {
    [CmdletBinding(DefaultParameterSetName = 'Silent')]
    [OutputType([bool], ParameterSetName = 'WithResult')]
    [OutputType([void], ParameterSetName = 'Silent')]
    param(
        [Parameter(
            Mandatory ,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name ,

        [Parameter(
            Mandatory ,
            ParameterSetName = 'WithResult'
        )]
        [Switch]
        $WithResult
    )

    Begin {
        $local:generators = Get-GeneratorSet
    }

    Process {
        $local:result = $local:generators.Add($Name)

        if ($WithResult) {
            $local:result
        }
    }
}