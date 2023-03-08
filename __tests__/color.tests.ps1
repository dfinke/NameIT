BeforeDiscovery {
    Import-Module "$PSScriptRoot\..\NameIT.psd1" -Force
}

Describe "color Generation Test (en culture)" -Tag color, CultureEn {

    BeforeEach {
        $null = Get-Random -SetSeed 1 
    }

    It "Generates a color (en culture)" {
        $actual = Invoke-Generate '[color]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'purple'
        $actual[1] | Should -BeExactly 'cyan'
        $actual[2] | Should -BeExactly 'purple'
        $actual[3] | Should -BeExactly 'white'
        $actual[4] | Should -BeExactly 'violet'
    }
}

Describe "color Generation Test (pl culture)" -Tag color, CulturePl {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Generates a color (pl culture)" {
        $actual = Invoke-Generate '[color]' -Count 5 -Culture pl

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'beżowy'
        $actual[1] | Should -BeExactly 'biały'
        $actual[2] | Should -BeExactly 'brązowy'
        $actual[3] | Should -BeExactly 'brunatny'
        $actual[4] | Should -BeExactly 'bursztynowy'
    }
}

Describe "color Generation Test (sv culture)" -Tag color, CultureSv {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Generates a color (sv culture)" {
        $actual = Invoke-Generate '[color]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'röd'
        $actual[1] | Should -BeExactly 'indigo'
        $actual[2] | Should -BeExactly 'rosa'
        $actual[3] | Should -BeExactly 'blå'
        $actual[4] | Should -BeExactly 'cyan'
    }
}
