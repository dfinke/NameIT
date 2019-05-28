@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'NameIT.psm1'

    # Version number of this module.
    ModuleVersion     = '2.1.1'

    # ID used to uniquely identify this module
    GUID              = '6d4ec85a-e09f-4024-819d-66bafa130a5b'

    # Author of this module
    Author            = 'Douglas Finke, Chris Hunt'

    # Company or vendor of this module
    CompanyName       = 'Doug Finke'

    # Copyright statement for this module
    Copyright         = 'c 2016 All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PowerShell module to randomly generate names'

    # Minimum version of the Windows PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = '*'

    # Cmdlets to export from this module
    CmdletsToExport   = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport   = '*'

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData       = @{
        GeneratorList = @(
            'alpha'
           ,'synonym'
           ,'numeric'
           ,'syllable'
           ,'vowel'
           ,'phoneticvowel'
           ,'consonant'
           ,'person'
           ,'address'
           ,'space'
           ,'noun'
           ,'adjective'
           ,'verb'
           ,'cmdlet'
           ,'state'
           ,'dave'
           ,'guid'
           ,'randomdate'
           ,'fortnite'
           ,'color'
        )
        
        CultureNorms = @{
            FallbackLang = 'en'
            CultureRoot = 'cultures'
        }

        # PSData is module packaging and gallery metadata embedded in PrivateData
        # It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
        # We had to do this because it's the only place we're allowed to extend the manifest
        # https://connect.microsoft.com/PowerShell/feedback/details/421837
        PSData = @{
            # The primary categorization of this module (from the TechNet Gallery tech tree).
            Category     = "Scripting"

            # Keyword tags to help users find this module via navigations and search.
            Tags         = @("NameIT", "Generator", "Random")

            # The web address of an icon which can be used in galleries to represent this module
            #IconUri = "http://pesterbdd.com/images/Pester.png"

            # The web address of this module's project or support homepage.
            ProjectUri   = "https://github.com/dfinke/NameIT"

            # The web address of this module's license. Points to a page that's embeddable and linkable.
            LicenseUri   = "https://github.com/dfinke/NameIT/blob/master/LICENSE.txt"

            # Release notes for this particular version of the module
            # ReleaseNotes = False

            # If true, the LicenseUrl points to an end-user license (not just a source license) which requires the user agreement before use.
            # RequireLicenseAcceptance = ""

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'False'
        }
    }

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
