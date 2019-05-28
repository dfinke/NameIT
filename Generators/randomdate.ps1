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

    $theRandomTicks = Get-Random -Minimum ([Convert]::ToDouble($MinDate.Ticks)) -Maximum ([Convert]::ToDouble($MaxDate.Ticks))
    [DateTime]::new([Convert]::ToInt64($theRandomTicks)).ToString($Format, $Culture.DateTimeFormat)
}
