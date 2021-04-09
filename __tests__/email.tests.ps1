Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "email Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a email title" {
        $actual = Invoke-Generate '[email]' -Count 5

        $actual[0] | Should -BeExactly 'holly.faulkner@hotmail.com'
        $actual[1] | Should -BeExactly 'raina.keith@hotmail.com'
        $actual[2] | Should -BeExactly 'henry.hernandez@yahoo.com'
        $actual[3] | Should -BeExactly 'rory.figueroa@yahoo.com'
        $actual[4] | Should -BeExactly 'leon.tapia@gmail.com'
    }
}
