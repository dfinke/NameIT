function email {
    # $tlds = 'com', 'com', 'com', 'net', 'org', 'es', 'es', 'es'

    $domain = 'gmail.com', 'yahoo.com', 'hotmail.com'

    "{0}@{1}" -f (person).tolower().replace(' ', '.'), ($domain | Get-Random)
}