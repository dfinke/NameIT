Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "country Gerneration Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a country title" {
        $actual = Invoke-Generate '[country]' -Count 5

        $actual[0] | Should -BeExactly 'Uruguay'
        $actual[1] | Should -BeExactly 'Eritrea'
        $actual[2] | Should -BeExactly 'Sri Lanka'
        $actual[3] | Should -BeExactly 'Guyana'
        $actual[4] | Should -BeExactly 'Burundi'
    }
}