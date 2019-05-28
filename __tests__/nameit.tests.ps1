$manifestPath = $PSScriptRoot | Join-Path -ChildPath '..' | Join-Path -ChildPath 'NameIT.psd1' | Resolve-Path
Import-Module $manifestPath -Force

Describe "NameIT Tests" {
    $StaticSeed = [System.Random]::new().Next()

    Context "Module Health" {
        It "Should have a valid module manifest" {
            Test-ModuleManifest -Path $manifestPath | Should BeOfType ([psmoduleinfo])
        }

        It "Should have a manifest that meets PSGallery Requirements" {
            # this catches one verified case so far of a valid manifest rejected by PSGallery
            # https://github.com/dfinke/NameIT/issues/24
            
            Import-PowerShellDataFile -Path $manifestPath | Should BeOfType [hashtable]
        }

        It "All Static Generators Should Exist as Functions" {
            InModuleScope NameIT {
                Clear-GeneratorSet
                $generators = Get-GeneratorSet -Enumerate
                Get-Command -CommandType Function -Name $generators | Should HaveCount $generators.Count
            }
        }
    }

    Context "Generation Tests" {

        InModuleScope NameIT {
            Clear-CacheStore
        }

        It "Should generate five entries" {
            $actual = Invoke-Generate -Template "[person]" -Count 5
            $actual.count | Should Be 5
        }

        It "Should return a culture-specific space character" {
            $actual = Invoke-Generate -Template '[space 1 ja-JP]'
            $actual -as [char] -as [int] | Should Be 12288
        }

        It "Should pass through culture from Invoke-Generate" {
            $actual = Invoke-Generate -Template '[space 1]' -Culture ja-JP
            $actual -as [char] -as [int] | Should Be 12288
        }

        It "'[space]' and a literal space should return the same results" {
            $spaceLit = Invoke-Generate -Template '[noun] [noun]' -SetSeed $StaticSeed
            $spaceGen = Invoke-Generate -Template '[noun][space][noun]' -SetSeed $StaticSeed

            $spaceLit | Should BeExactly $spaceGen
        }

        It "'[space 5]' and 5 literal spaces should return the same results" {
            $spaceLit = Invoke-Generate -Template '[noun]     [noun]' -SetSeed $StaticSeed
            $spaceGen = Invoke-Generate -Template '[noun][space 5][noun]' -SetSeed $StaticSeed

            $spaceLit | Should BeExactly $spaceGen
        }

        It "Spaces in quoted arguments should behave" {
            $dateHyphen = Invoke-Generate -Template "[randomdate 1/1/1999 5/5/5555 'yyyy-MM-dd']" -SetSeed $StaticSeed
            $dateSpace = Invoke-Generate -Template "[randomdate 1/1/1999 5/5/5555 'yyyy MM dd']" -SetSeed $StaticSeed

            $dateSpace | Should BeExactly $dateHyphen.Replace('-', ' ')
        }

        It "Newlines in a template should behave" {
            { 
                Invoke-Generate -Template '[noun]
            
                [noun]'
            } | Should Not Throw
        }

        It "Newlines in a quoted argument should behave" {
            # https://github.com/dfinke/NameIT/issues/29

        #     $dateGen = Invoke-Generate -Template "[randomdate 1/1/1999 5/5/5555 'yyyy']" -SetSeed $StaticSeed
        #     $dateNlGen = Invoke-Generate -Template "[randomdate 1/1/1999 5/5/5555 'yyyy
        #     2
        #     3']" -SetSeed $StaticSeed

        #     "$dateGen
        #     2
        #     3" | Should BeExactly $dateNlGen
        }

        It "Internal Aliases shouldn't expand inside arguments" {
            # https://github.com/dfinke/NameIT/issues/30
        }
    }
}