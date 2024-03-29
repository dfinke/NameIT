﻿BeforeDiscovery {
    Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force
}


Describe "City Generation Test (culture en)" -Tag City, CultureEn {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a city (en culture)" {
        $actual = Invoke-Generate '[city]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Tryon'
        $actual[1] | Should -BeExactly 'Pamplin'
        $actual[2] | Should -BeExactly 'Columbia'
        $actual[3] | Should -BeExactly 'Conover'
        $actual[4] | Should -BeExactly 'Tunkhannock'
    }

    It "Tests returning a county (en culture)" {
        $actual = Invoke-Generate '[city county]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
        
        $actual[0] | Should -BeExactly 'POLK'
        $actual[1] | Should -BeExactly 'APPOMATTOX'
        $actual[2] | Should -BeExactly 'RICHLAND'
        $actual[3] | Should -BeExactly 'CATAWBA'
        $actual[4] | Should -BeExactly 'WYOMING'
    }
}

Describe "City Generation Test (culture sv)" -Tag City, CultureSv {
    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a city (sv culture)" -Tag City, CultureSv {
        $actual = Invoke-Generate '[city]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Duvesjön'
        $actual[1] | Should -BeExactly 'Piperskärr'
        $actual[2] | Should -BeExactly 'Sälen'
        $actual[3] | Should -BeExactly 'Vedevåg'
        $actual[4] | Should -BeExactly 'Hjortkvarn'
    }

    It "Tests returning a county (sv culture)" -Tag City, CultureSv {
        $actual = Invoke-Generate '[city county]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
        
        $actual[0] | Should -BeExactly 'Kungälv'
        $actual[1] | Should -BeExactly 'Västervik'
        $actual[2] | Should -BeExactly 'Malung-Sälen'
        $actual[3] | Should -BeExactly 'Lindesberg'
        $actual[4] | Should -BeExactly 'Hallsberg'
    }
}