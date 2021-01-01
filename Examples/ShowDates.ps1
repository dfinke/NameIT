Import-Module "$PSScriptRoot\..\nameit.psd1" -Force

$templates = $(
    'ThisQuarter'
    'q1', 'q3', 'q3', 'q4'
    'Today', 'Tomorrow', 'Yesterday'
    'February', 'April', 'October'
)

foreach ($template in $templates) {
    $template | ForEach-Object {
        [PSCustomObject]@{
            Template = $_
            Result   = Invoke-Generate "$_" 
        }
    }
}