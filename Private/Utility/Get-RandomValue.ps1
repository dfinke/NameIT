<#
.Synopsis
   Utilize Invoke-Generate to create a random value with a specified type.

.DESCRIPTION
   NameIt returns strings including unecessary zeros in numbers. Get-RandomValue returns a specified values type.

.PARAMETER Template
   A Nameit template string.

.PARAMETER As
   A type name specifying the return type of the command.

.PARAMETER Alphabet
   A set of alpha characters used to generate random strings.

.PARAMETER Numbers
   A set of digit characters used to generate random numerics.

.EXAMPLE
   PS C:\> 1..3 | % {Get-RandomValue "###.##" -as double}
   75.41
   439.92
   195.55

.EXAMPLE
   PS C:\> 1..3 | % {Get-RandomValue "#.#.#" -as version}

   Major  Minor  Build  Revision
   -----  -----  -----  --------
   1      3      1      -1
   2      2      5      -1
   7      1      0      -1
#>
function Get-RandomValue {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Template,

        [Parameter(Position = 1)]
        [Type]
        $As,

        [Parameter(Position = 2)]
        [string]
        $Alphabet,

        [Parameter(Position = 3)]
        [string]
        $Numbers
    )

    $type = $null

    if ( $PSBoundParameters.ContainsKey('As') ) {

        $type = $As

    }

    $null = $PSBoundParameters.Remove('As')
    $stringValue = Invoke-Generate @PSBoundParameters

    if ( -not $null -eq $type ) {

        $returnValue = $stringValue -as $type
        if ($null -eq $returnValue) {

            Write-Warning "Could not cast '$stringValue' to [$($type.Name)]"

        }

    }
    else {

        $returnValue = $stringValue

    }

    $returnValue
}
