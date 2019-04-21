function synonym {
    param ([string]$word)

    $url = "http://words.bighugelabs.com/api/2/78ae52fd37205f0bad5f8cd349409d16/$($word)/json"

    $synonyms = $(foreach ($item in (Invoke-RestMethod $url)) {
            $names = $item.psobject.Properties.name
            foreach ($name in $names) {
                $item.$name.syn -replace ' ', ''
            }
        }) | Where-Object -FilterScript { $_ }

    $max = $synonyms.Length
    $synonyms[(Get-Random -Minimum 0 -Maximum $max)]
}
