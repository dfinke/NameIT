Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Character tests" -Tag Generators {
    Context "When executed without parameters" {
        It "Returns a string object that is not null" {
            $result = Invoke-Generate "[character]"
            $result | Should -BeOfType System.String
            $result | Should -Not -BeNullOrEmpty
        }

        BeforeEach {
            $null = Get-Random -SetSeed 1
        }

        It "Returns a single character only" {
            $result = Invoke-Generate "[character]"
            $result.length | Should -Be 1
        }
    }

    Context "When executed with the CharType parameter" -ForEach @(
        @{ CharType = 'Letter'; Value = 'n' }
        @{ CharType = 'Number'; Value = '2' }
        @{ CharType = 'Symbol'; Value = '(' }
    ){
        BeforeEach {
            $null = Get-Random -SetSeed 1
        }

        It "Returns '<Value>' as a string: <CharType>" {
            $result = Invoke-Generate "[character -CharType $CharType]"
            $result | Should -BeOfType System.String
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeExactly $Value
        }
    }

    Context "When executed with the Case parameter" -ForEach @(
        @{ Case = 'Upper'; Value = 'B' }
        @{ Case = 'Lower'; Value = 'h' }
    ){
        BeforeEach {
            $null = Get-Random -SetSeed 1
        }

        It "Returns '<Value> as a string: <Case>" {
            $result = Invoke-Generate "[character -Case $Case]"
            $result | Should -BeOfType System.String
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeExactly $Value
        }
    }

    Context "When executed with the ReturnSet parameter" -ForEach @(
        @{ ReturnSet = 'Vowel'; Value = 'a' }
        @{ ReturnSet = 'Consonant'; Value = 's' }
    ){
        BeforeEach {
            $null = Get-Random -SetSeed 1
        }

        It "Returns '<Value> as a string: <ReturnSet>" {
            $result = Invoke-Generate "[character -ReturnSet $ReturnSet]"
            $result | Should -BeOfType System.String
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeExactly $Value
        }
    }

    Context "When executed with both the Case and ReturnSet parameters" -ForEach @(
        @{ ReturnSet = 'Vowel'; Case = 'Upper'; Value = 'E' }
        @{ ReturnSet = 'Vowel'; Case = 'Lower'; Value = 'e' }
        @{ ReturnSet = 'Consonant'; Case = 'Upper'; Value = 'S' }
        @{ ReturnSet = 'Consonant'; Case = 'Lower'; Value = 's' }
    ){
        BeforeEach {
            $null = Get-Random -SetSeed 1
        }

        It "Returns '<Value> as a string: <ReturnSet> - <Case>" {
            $result = Invoke-Generate "[character -ReturnSet $ReturnSet -Case $Case]"
            $result | Should -BeOfType System.String
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeExactly $Value
        }
    }
}