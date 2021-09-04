Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "company Generation Test" {

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

    It "Tests returning a company suffix" {
        $actual = Invoke-Generate '[company suffix]' -Count 5

        $actual[0] | Should -BeExactly 'and Sons'
        $actual[1] | Should -BeExactly 'and Sons'
        $actual[2] | Should -BeExactly 'LLC'
        $actual[3] | Should -BeExactly 'PLC'
        $actual[4] | Should -BeExactly 'Ltd'
    }

    It "Tests returning a fluff word" {
        $actual = Invoke-Generate '[company fluff]' -Count 5

        $actual[0] | Should -BeExactly 'experiences'
        $actual[1] | Should -BeExactly 'eyeballs'
        $actual[2] | Should -BeExactly 'relationships'
        $actual[3] | Should -BeExactly 'global'
        $actual[4] | Should -BeExactly 'reinvent'
    }

    It "Tests returning a catch word" {
        $actual = Invoke-Generate '[company catch]' -Count 5

        $actual[0] | Should -BeExactly 'database'
        $actual[1] | Should -BeExactly 'collaboration'
        $actual[2] | Should -BeExactly 'Stand-alone'
        $actual[3] | Should -BeExactly 'User-friendly'
        $actual[4] | Should -BeExactly 'empowering'
    }
}