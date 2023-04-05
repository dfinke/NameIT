BeforeDiscovery {
    Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force
}


Describe "City Generation Test (culture en)" -Tag City, CultureEn {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a city (en culture)" {
        $actual = Invoke-Generate '[city]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Raisdorf'
        $actual[1] | Should -BeExactly 'Pointe Saint-Martin'
        $actual[2] | Should -BeExactly 'Miquelon'
        $actual[3] | Should -BeExactly 'Tulcea'
        $actual[4] | Should -BeExactly 'Hurley'
    }

    It "Tests returning a county (en culture)" {
        $actual = Invoke-Generate '[city county]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
        
        $actual[0] | Should -BeExactly 'Reg.-Bez. Detmold'
        $actual[1] | Should -BeExactly 'Kasungu Municipality'
        $actual[2] | Should -BeExactly 'Réunion'
        $actual[3] | Should -BeExactly ''
        $actual[4] | Should -BeExactly 'Lucas'
    }
}

Describe "City Generation Test (culture sv)" -Tag City, CultureSv {
    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a city (sv culture)" -Tag City, CultureSv {
        $actual = Invoke-Generate '[city]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Raisdorf'
        $actual[1] | Should -BeExactly 'Pointe Saint-Martin'
        $actual[2] | Should -BeExactly 'Miquelon'
        $actual[3] | Should -BeExactly 'Tulcea'
        $actual[4] | Should -BeExactly 'Hurley'
    }

    It "Tests returning a county (sv culture)" -Tag City, CultureSv {
        $actual = Invoke-Generate '[city county]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
        
        $actual[0] | Should -BeExactly 'Reg.-Bez. Detmold'
        $actual[1] | Should -BeExactly 'Monaco'
        $actual[2] | Should -BeExactly 'Miquelon-Langlade'
        $actual[3] | Should -BeExactly 'Bucureşti'
        $actual[4] | Should -BeExactly ''
    }
}