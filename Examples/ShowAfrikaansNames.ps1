Import-Module "$PSScriptRoot\..\nameit.psd1" -Force

Invoke-Generate -Template "[person]" -Count 5  -Culture af
Invoke-Generate -Template "[person female first]" -Count 5  -Culture af
Invoke-Generate -Template "[person male first]" -Count 5  -Culture af
Invoke-Generate -Template "[color]" -Count 5  -Culture af
