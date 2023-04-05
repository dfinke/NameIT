Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "company Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a company title" {
        $actual = Invoke-Generate '[company]' -Count 5

        $actual[0] | Should -BeExactly 'Grandmaison PLC'
        $actual[1] | Should -BeExactly 'Czerwinski-Hochwalt'
        $actual[2] | Should -BeExactly 'Laredo-Linn'
        $actual[3] | Should -BeExactly 'Charming Alcohol Group'
        $actual[4] | Should -BeExactly 'Irate Resolve Inc'
    }

    It "Tests returning a company suffix" {
        $actual = Invoke-Generate '[company suffix]' -Count 5

        $actual[0] | Should -BeExactly 'Ltd'
        $actual[1] | Should -BeExactly 'College'
        $actual[2] | Should -BeExactly 'and Sons'
        $actual[3] | Should -BeExactly 'LLC'
        $actual[4] | Should -BeExactly 'Association'
    }

    It "Tests returning a fluff word" {
        $actual = Invoke-Generate '[company fluff]' -Count 5

        $actual[0] | Should -BeExactly 'e-tailers'
        $actual[1] | Should -BeExactly 'virtual'
        $actual[2] | Should -BeExactly 'B2C'
        $actual[3] | Should -BeExactly 'implement'
        $actual[4] | Should -BeExactly 'synergize'
    }

    It "Tests returning a catch word" {
        $actual = Invoke-Generate '[company catch]' -Count 5

        $actual[0] | Should -BeExactly 'explicit'
        $actual[1] | Should -BeExactly 'Distributed'
        $actual[2] | Should -BeExactly 'Internet solution'
        $actual[3] | Should -BeExactly 'value-added'
        $actual[4] | Should -BeExactly '6thgeneration'
    }
}