function RandomDate {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias('TheMin')]
        [DateTime]
        $MinDate = [DateTime]::MinValue,

        [Parameter()]
        [Alias('TheMax')]
        [DateTime]
        $MaxDate = [DateTime]::MaxValue ,

        [Parameter()]
        [String]
        $Format ,

        [Parameter()]
        [cultureinfo]
        $Culture = [cultureinfo]::CurrentCulture
    )

    if (-not $Format) {
        $Format = $Culture.DateTimeFormat.ShortDatePattern
    }

    $theRandomGen = New-Object random
    $theRandomTicks = [Convert]::ToInt64( ($MaxDate.ticks * 1.0 - $MinDate.Ticks * 1.0 ) * $theRandomGen.NextDouble() + $MinDate.Ticks * 1.0 )

    (New-Object DateTime $theRandomTicks).ToString($Format, $Culture.DateTimeFormat)
}
