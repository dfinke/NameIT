Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "company Gerneration Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a company title" {
        $actual = Invoke-Generate '[company]' -Count 5

        $actual[0] | Should -BeExactly 'Jefferson-Hernandez'
        $actual[1] | Should -BeExactly 'Wells Inc'
        $actual[2] | Should -BeExactly 'Carter, Arnold and Bass'
        $actual[3] | Should -BeExactly 'Dougherty-Haynes'
        $actual[4] | Should -BeExactly 'Briggs-Forbes'
    }
}