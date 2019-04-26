Import-Module "$PSScriptRoot/../NameIT.psd1" -Force

Describe "NameIT Tests" {

    Context "Module Health" {
        It "Should have a valid module manifest" {
            Test-ModuleManifest -Path $PSScriptRoot\..\NameIT.psd1 | Should BeOfType ([psmoduleinfo])
        }

        It "Should have a manifest that meets PSGallery Requirements" {
            # this catches one verified case so far of a valid manifest rejected by PSGallery
            # https://github.com/dfinke/NameIT/issues/24
            
            Import-PowerShellDataFile -Path $PSScriptRoot\..\NameIt.psd1 | Should BeOfType [hashtable]
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
    }
}