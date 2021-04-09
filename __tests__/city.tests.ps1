Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "City Generation Test" -Tag City {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a city" {
        $actual = Invoke-Generate '[city]' -Count 5

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Tryon'
        $actual[1] | Should -BeExactly 'Pamplin'
        $actual[2] | Should -BeExactly 'Columbia'
        $actual[3] | Should -BeExactly 'Conover'
        $actual[4] | Should -BeExactly 'Tunkhannock'
    }

    It "Tests returning a county" {
        $actual = Invoke-Generate '[city county]' -Count 5

        $actual.Count | Should -Be 5
        
        $actual[0] | Should -BeExactly 'POLK'
        $actual[1] | Should -BeExactly 'APPOMATTOX'
        $actual[2] | Should -BeExactly 'RICHLAND'
        $actual[3] | Should -BeExactly 'CATAWBA'
        $actual[4] | Should -BeExactly 'WYOMING'
    }
}