function syllable {
    param ([Switch]$usePhoneticVowels)

    $syllables = ((vowel) + (consonant)), ((consonant) + (vowel)), ((consonant) + (vowel) + (consonant))

    if ($usePhoneticVowels) {
        $syllables += ((consonant) + (phoneticVowel))
    }

    Get-RandomChoice $syllables
}
