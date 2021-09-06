Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Afrikaans Werk(Work) Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a job title in afrikaans" {
        $actual = Invoke-Generate '[werk]' -Count 5

        $actual[0] | Should -BeExactly 'Rekenaar Wetenskaplike'
        $actual[1] | Should -BeExactly 'Chirug'
        $actual[2] | Should -BeExactly 'Visserman'
        $actual[3] | Should -BeExactly 'Kok'
        $actual[4] | Should -BeExactly 'Kok'
    }
}