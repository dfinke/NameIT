Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "postalCode Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a postalCode title" {
        $actual = Invoke-Generate '[postalCode]' -Count 5

        $actual[0] | Should -BeExactly '67218'
        $actual[1] | Should -BeExactly '44164'
        $actual[2] | Should -BeExactly '30353'
        $actual[3] | Should -BeExactly '72211'
        $actual[4] | Should -BeExactly '37205'
    }
}
