<!-- chapter start -->
# NameIT

PowerShell module for randomly generating names.

- [GitHub Repo](https://github.com/dfinke/NameIT)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/NameIT)

Try it below, change the parameters passed, click run and see the results.

## Install the Module

```ps
# exclude results
# Install-Module NameIT -force
```

## Getting Started

Let's try it out.

## Generate PowerShell Window Titles or Machine Names

```ps
Invoke-Generate "[Adjective]_[Noun]" -Count 5
```

## Fake Data

Generate an eight character name with a random set of characters.

```ps
Invoke-Generate
```

Generates an eight character name with a random set of characters in the A-Z alphabet. You can change which alphabet is being used by using the `-alphabet` parameter.

```ps
Invoke-Generate -alphabet abc
```
This is just a default template, most users will have some idea of what they want to generate, but want to randomly splice in other characters to make it unique or come up with some other ideas. For this you can provide a template string.

```ps
Invoke-Generate "cafe###"
```

Using the `?` symbol injects a random letter, the `#` symbol injects a random number.

```ps
Invoke-Generate "???###"
```

## Template Functions
The ```?``` and ```#``` characters in a template are just shorthand for functions that you can use in a template, so the previous example could also be written as:

```ps
Invoke-Generate "[alpha][alpha][alpha][numeric][numeric][numeric]"
```
NameIT exposes several useful functions to help create more useful (and pronounceable names). Here is the current list:

- `[alpha]`; selects a random character (constrained by the ```-alphabet` parameter).
- `[numeric]`; selects a random numeric (constrained by the `-numbers` parameter).
- `[vowel]`; selects a vowel from *a*, *e*, *i*, *o* or *u*.
- `[phoneticVowel]`; selects a vowel sound, for example *ou*.
- `[consonant]`; selects a consonant from the entire alphabet.
- `[syllable]`; generates (usually) a pronouncable single syllable.
- `[synonym word]`; finds a synonym to match the provided word.
- `[person]`; generate random name of female or male based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[person female]`;generate random name of female based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[person male]`;generate random name of male based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[address]`; generate a random street address. Formatting is biased to US currently.
- `[space]`; inserts a literal space. Spaces are striped from the templates string by default.

One of the most common functions you'll use is `[syllable()]` because it generally produces something that you can pronounce. For example, if we take our earlier cafe naming example, you might do something like this:

```ps
Invoke-Generate "cafe_[syllable][syllable]"
```

You can also get the tool to generate more than one name at a time using the ```--count``` parameter. Here is an example:

```ps
Invoke-Generate -count 5 "[synonym cafe]_[syllable][syllable]"
```

<!-- chapter end -->