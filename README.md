<p align="center">
<a <a href="https://dougfinke.visualstudio.com/NameIT/_build/latest?definitionId=19&branchName=master"><img src="https://dougfinke.visualstudio.com/NameIT/_apis/build/status/dfinke.NameIT?branchName=master"></a>
<a <a href="https://ci.appveyor.com/project/dfinke/nameit/branch/master"><img src="https://ci.appveyor.com/api/projects/status/dd6c12ba9q9ojiba/branch/master?svg=true"></a>
</p>

<!-- [![Build Status](https://dougfinke.visualstudio.com/NameIT/_apis/build/status/dfinke.NameIT?branchName=master)](https://dougfinke.visualstudio.com/NameIT/_build/latest?definitionId=19&branchName=master) -->

<!-- [![Build status](https://ci.appveyor.com/api/projects/status/dd6c12ba9q9ojiba/branch/master?svg=true)](https://ci.appveyor.com/project/dfinke/nameit/branch/master) -->

<p align="center">
<a <a href="./LICENSE.txt"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"></a>
<a href="https://www.powershellgallery.com/packages/NameIT"><img src="https://img.shields.io/powershellgallery/dt/NameIT.svg"></a>
<a href="https://www.powershellgallery.com/packages/NameIT"><img src="https://img.shields.io/powershellgallery/v/NameIT.svg"></a>
</p>

PowerShell NameIT
-
PowerShell module for randomly generating names

This project is a port of https://github.com/mitchdenny/namerer. Hat tip to [Mitch Denny](https://twitter.com/mitchdenny).

## v2.3.3

- Check [Change log](./changelog.md) for new templates
## v2.3.2
- Added `job` to template

```powershell
ig '[person],[job]' -count 3

Alexandria Stephens,Biologist
Braiden Patel,Social media coordinator
Mya Perez,Principal
```

## v2.3.2

[Göran Hanell](https://github.com/imaginetobe) added names and color in Swedish.

```powershell
ig '[color]' -Culture sv-SE -Count 5

grön
vit
orange
grå
rosa
```


```powershell
ig '[person]' -Culture sv-SE -Count 5

Helen Holmberg
Sten Samuelsson
Sven Abrahamsson
Mona Ahmed
Anette Dahlberg
```

## v2.3.0

- Added

```powershell
# Run on 12/31/2020

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
```

## Prints

Generates these random dates.
```
Template    Result
--------    ------
ThisQuarter 10/23/2020
q1          3/15/2020
q3          7/12/2020
q3          9/18/2020
q4          10/12/2020
Today       12/31/2020
Tomorrow    1/1/2021
Yesterday   12/30/2020
February    2/15/2020
April       4/13/2020
October     10/8/2020
```

|Item|Description|
|---|---|
|January|Generate a random date for this month|
|February|Generate a random date for this month|
|March|Generate a random date for this month|
|April|Generate a random date for this month|
|May|Generate a random date for this month|
|June|Generate a random date for this month|
|July|Generate a random date for this month|
|August|Generate a random date for this month|
|September|Generate a random date for this month|
|October|Generate a random date for this month|
|November|Generate a random date for this month|
|December|Generate a random date for this month|
|ThisQuarter|Generate a random date for this quarter|
|Q1|Generate a random date for Q1|
|Q2|Generate a random date for Q2|
|Q3|Generate a random date for Q3|
|Q4|Generate a random date for Q4|
|LastQuarter|Generate a random date for last quarter|
|NextQuarter|Generate a random date for next quarter|
|Today|Generate todays date|
|Tomorrow|Generate tomorrows date|
|Yesterday|Generate yesterdays date|


## April 2019 - 2.1.0
Language/Culture can be passed directly to `Invoke-Generate`, which will apply to everything without an explicit override.

```powershell
ig "[color][space][color en-GB]" -Culture ja-JP
```

This is especially easier when there's lots of arguments you have to get through to get to specify culture (last).

```powershell
ig "[randomdate]"                                           # implicitly uses culture short date format
ig "[randomdate 1/1/1999 12/31/1999 'yyyy-MM-dd' ja-JP]"    # can't use culture format this way, have to specify format explicitly
ig "[randomdate]" -Culture ja-JP                            # lets the other arguments remain optional
```

* Fixed module auto-loading from a regression in 2.1.0, and includes some internal fixes and changes.
* Internal refactor to individual files.
* Support added for multiple languages and cultures. Tries to give you results based on your current culture, or a specific one you provide.

![image](https://raw.githubusercontent.com/dfinke/NameIT/master/images/MultipleLanguages.png)

```powershell
ig "[color]"        # your current culture
ig "[color en-GB]"  # choosing lang-CULTURE
ig "[color ja]"     # choosing lang only
```

Falls back to "something in your chosen language" if specific culture is not available.
Falls back to US English (en-US) if your language is not available at all.

```powershell
ig "[color en-CA]"  # returns US English color because no Canadian English colors are defined (as of this writing)
ig "[noun en-GB]"   # returns US English noun because even though British English exists, there's no nouns file
ig "[color es]"     # returns US English because no Spanish language files exist yet
```

`randomdate` can now take a lower and upper bound on time and a format string.
By default uses chosen culture's short date format.

```powershell
ig "[randomdate]"                                           # a random date in my culture format
ig "[randomdate '1/1/2000']"                                # a random date from 1 Jan 2000 onward
ig "[randomdate '1/1/2000' '12/31/2000']"                   # a random date in the year 2000
ig "[randomdate '1/1/2000' '12/31/2000' 'dd MMM yyyy']"     # a random date in 2000 with a custom format
```

More information coming soon for contributors on how to deal (or not) with culture stuff.

## September 2018

Added `New-NameItTemplate`. Pass an object with properties and it will generate a `NameIT` template.

If a property name has has the value `name`, `zip`, `address`, or `state` the appropriate `NameIT` template is applied, otherwise the type is inferred as numeric or alpha.

```powershell
New-NameItTemplate {[PSCustomObject]@{Company="";Name=""}}
```

```
Company=[alpha 6]
Name=[person]
```

### OR

Pass it to `Invoke-Generate` directly.

```powershell
Invoke-Generate (New-NameItTemplate {[PSCustomObject]@{Company="";Name=""}}) -Count 5 -AsPSObject
```

## Output

```
Name          Company
----          -------
Elvis Potts   cuajwj
Janae Herring kyzfgb
Cecelia Cruz  slseam
Akira Kelly   bltamv
Bella Bean    wfhats
```


## In Action

![image](https://raw.githubusercontent.com/dfinke/NameIT/master/images/nameit.gif)

![image1](https://github.com/dfinke/NameIT/blob/master/images/nameitAddressVerbNounAdjective.gif?raw=true)


## 7/10/2018
- Added badges
- Added first|last for `person` address issue https://github.com/dfinke/NameIT/issues/16

```
[person female first]
[person female last]
[person male first]
[person male last]
[person both first]
[person both last]
```

## Release 1.8.5 : 6/18/2018
Added `RandomDate`

```powershell
ig "[person] [randomdate]" -Count 5
```

```
Austin Jones 06/04/2007
Kristin Hernandez 06/04/2007
Lindsay Richardson 06/04/2007
Alex Morales 06/04/2007
Nicholas Sanders 06/04/2007
```

## Release 1.8.2 : 03/5/2017
Added more adjectives and stored them randomly, suggested by [Joel Bennett](https://twitter.com/Jaykul).

Added `guid` to the template. *Chris Hunt* suggested and then delegated the implementation to me after I showed him I was randomly generating guid parts.

```powershell
Invoke-Generate "[guid]"
Invoke-Generate "[guid 0]"
Invoke-Generate "[guid 3]"
```

```
690dcb11-a5b5-462a-a860-8de11626f5fd
eeb507b0
9873
```

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

Or [try this gist snippet](https://gist.github.com/cdhunt/00a6f98b9d7773b2610bdc6d490ad217).

![](https://raw.githubusercontent.com/dfinke/NameIT/master/images/nameitConsoleTitle.png)

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
- `[consonant]`; selects a consonant from the entire alphabet.
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
