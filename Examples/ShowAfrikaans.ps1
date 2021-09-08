Import-Module "$PSScriptRoot\..\nameit.psd1" -Force

$templates = $(
    'person female first', 'person male first', 
    'person','address', 'color', 'jobAfrikaans', 'adjective','noun'
)

foreach ($template in $templates) {
  $template | ForEach-Object {
      [PSCustomObject]@{
          Template = $_
          Result   = Invoke-Generate "[$_]" -Culture 'af'
      }
  }
}