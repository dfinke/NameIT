Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "email Generation Test (en culture)" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a email title" {
        $actual = Invoke-Generate '[email]' -Count 5 -Culture en

        $actual[0] | Should -BeExactly 'holly.faulkner@hotmail.com'
        $actual[1] | Should -BeExactly 'raina.keith@hotmail.com'
        $actual[2] | Should -BeExactly 'henry.hernandez@yahoo.com'
        $actual[3] | Should -BeExactly 'rory.figueroa@yahoo.com'
        $actual[4] | Should -BeExactly 'leon.tapia@gmail.com'
    }
}
Describe "email Generation Test (sv culture)" -Tag CultureSv {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a email title" {

        $actual = Invoke-Generate '[email]' -Count 5 -Culture sv

        $actual[0] | Should -BeExactly 'hanna.falk@hotmail.com'
        $actual[1] | Should -BeExactly 'rebecca.johansson@hotmail.com'
        $actual[2] | Should -BeExactly 'jan.holm@yahoo.com'
        $actual[3] | Should -BeExactly 'rut.falk@yahoo.com'
        $actual[4] | Should -BeExactly 'marcus.ström@gmail.com'
    }
}
