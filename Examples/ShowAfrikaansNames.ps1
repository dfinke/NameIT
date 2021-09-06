Import-Module "$PSScriptRoot\..\nameit.psd1" -Force

Write-Host "   *** South African People"
Invoke-Generate -Template "[person]" -Count 5  -Culture af
Write-Host "   *** South African Women"
Invoke-Generate -Template "[person female first]" -Count 8  -Culture af
Write-Host "   *** South African Surnames"
Invoke-Generate -Template "[person male last]" -Count 5  -Culture af
Write-Host "   *** South African Colors"
Invoke-Generate -Template "[color]" -Count 5  -Culture af
Write-Host "   *** South African Jobs"
Invoke-Generate -Template "[werk]" -Count 5
Write-Host "   *** South African Adjectives"
Invoke-Generate -Template "[adjective]" -Count 5  -Culture af