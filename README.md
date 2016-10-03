PowerShell NameIT
-
PowerShell module for randomly generating names

This project is a port of https://github.com/mitchdenny/namerer. Hat tip to [Mitch Denny](https://twitter.com/mitchdenny).

## In Action

![image](https://raw.githubusercontent.com/dfinke/NameIT/master/images/nameit.gif)

![image1](https://github.com/dfinke/NameIT/blob/master/images/nameitAddressVerbNounAdjective.gif?raw=true)

## Release 1.7.0 : 10/3/2016
* Generate random cmdlet names (verb-noun) and limit it to approved verbs

```powershell
PS C:\> Invoke-Generate "[cmdlet]" -c 3
Boat-Other
Lawyer-South
Loose-Trip
PS C:\> Invoke-Generate "[cmdlet]" -c 3 -ApprovedVerb
Request-Purchase
Push-Grocery
Format-River
```

* Thank you [Chris Hunt](https://github.com/cdhunt) for: 
    * Adding the `address` feature (and more)
    * Suggesting of adding adjective, noun and verb

## Manage Your PowerShell Window Titles
Put this line in your `$Profile`.

`$Host.UI.RawUI.WindowTitle = Invoke-Generate "PowerShell[space]-[space][Adjective][Noun]"`

![](https://raw.githubusercontent.com/dfinke/NameIT/f35ff2f2b2ff80b2d9e008d82c620588d780a494/images/nameitConsoleTitle.png)
 
```PowerShell
PS C:\> Invoke-Generate "[person],[space][address][space]" -c 5
Derrick Cox, 1 Yicxizehpuw Av
Bethany Jones, 237 Tataqe Keys
Courtney Lewis, 162 Goyinu Ranch
Stacy Davis, 127 Odwus Lgt
Shane Carter, 308 Qeep Harb
```
## Release 1.04: 1/16/2016

* Thank you [Wojciech Sciesinski](https://github.com/it-praktyk) for adding the NameIT `person` feature

```
PS C:\> Invoke-Generate "[person]" -c 3
Meghan Cruz
Cassandra Smith
Luis Flores
PS C:\> Invoke-Generate "[person female]" -c 3
Heather Rogers
Meghan Bailey
Julia Perez
PS C:\> Invoke-Generate "[person male]" -c 3
Chad Bailey
Jordan Gray
Matthew Jackson
```


## Examples

```powershell
Invoke-Generate
# Output:
lhcqalmf
```
Will generate an eight character name with a random set of characters in the A-Z alphabet. You can change which alphabet is being used by using the `-alphabet` parameter.

```powershell
Invoke-Generate -alphabet abc
# Output:
cabccbca
```

This is just a default template, most users will have some idea of what they want to generate, but want to randomly splice in other characters to make it unique or come up with some other ideas. For this you can provide a template string.

```powershell
Invoke-Generate "cafe###"
# Output:
cafe176
```

Using the `?` symbol injects a random letter, the `#` symbol injects a random number.

```powershell
Invoke-Generate "???###"
# Output:
yhj561
```

## Template Functions
The ```?``` and ```#``` characters in a template are just shorthand for functions that you can use in a template, so the previous example could also be written as:

```powershell
Invoke-Generate "[alpha][alpha][alpha][numeric][numeric][numeric]"
# Output:
voe336
```

NameIT exposes a bunch of useful functions to help create more useful (and pronouncable names). Here is the current list that is supported:

- `[alpha]`; selects a random character (constrained by the ```-alphabet` parameter).
- `[numeric]`; selects a random numeric (constrained by the `-numbers` parameter).
- `[vowel]`; selects a vowel from *a*, *e*, *i*, *o* or *u*.
- `[phoneticVowel]`; selects a vowel sound, for example *ou*.
- `[consonant()]`; selects a consonant from the entire alphabet.
- `[syllable]`; generates (usually) a pronouncable single syllable.
- `[synonym word]`; finds a synonym to match the provided word.
- `[person]`; generate random name of female or male based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[person female]`;generate random name of female based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[person male]`;generate random name of male based on provided culture like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt;.
- `[address]`; generate a random street address. Formatting is biased to US currently.
- `[space]`; inserts a literal space. Spaces are striped from the templates string by default.

One of the most common functions you'll use is `[syllable()]` because it generally produces something that you can pronounce. For example, if we take our earlier cafe naming example, you might do something like this:

```powershell
Invoke-Generate "cafe_[syllable][syllable]"
# Output:
cafe_amoy
```

You can combine the tempalate functions to produce some interesting results, for example here we use the `[synonym]` function with the `[syllable]` function to also replace the word *cafe*.

```powershell
Invoke-Generate "[synonym cafe]_[syllable][syllable]"
# Output:
coffeehouse_iqza
```

You can also get the tool to generate a bunch of names at a time using the ```--count``` switch. Here is an example:

```powershell
Invoke-Generate -count 5 "[synonym cafe]_[syllable][syllable]"
# Output:
restaurant_owkub
coffeebar_otqo
eatingplace_umit
coffeeshop_fexuz
coffeebar_zuvpe
```

You can generate also names of people like &lt;FirstName&gt;&lt;Space&gt;&lt;LastName&gt; based on provided sex (female/male/both) and culture (currently only en-US).
The cultures can be added by putting csv files with the last/first names in the subfoders "cultures", in the module directory - please see en-US.csv for the file structure.

```powershell
Invoke-Generate "[person female]" -count 3
# Output:
Jacqueline Walker
Julie Richardson
Stacey Powell
```

## Stay tuned for additional capability
