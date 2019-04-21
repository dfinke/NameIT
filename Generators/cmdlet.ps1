function cmdlet {
    if ($ApprovedVerb) {
        $verb = (Get-Verb | Get-Random).verb
    }
    else {
        $verb = (verb)
    }

    "{0}-{1}" -f $verb, (noun)
}
