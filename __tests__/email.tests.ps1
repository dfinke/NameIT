Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "email Generation Test (en culture)" -Tag Email, CultureEn {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a email title" {
        $actual = Invoke-Generate '[email]' -Count 5 -Culture en

        $actual[0] | Should -BeExactly 'eric.leatherman@gmail.com'
        $actual[1] | Should -BeExactly 'shavon.hynd@gmail.com'
        $actual[2] | Should -BeExactly 'essie.genest@gmail.com'
        $actual[3] | Should -BeExactly 'tamara.ridgeon@yahoo.com'
        $actual[4] | Should -BeExactly 'mose.bertsch@yahoo.com'
    }
}

Describe "email Generation Test (sv culture)" -Tag Email, CultureSv {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a email title" {

        $actual = Invoke-Generate '[email]' -Count 5 -Culture sv

        $actual[0] | Should -BeExactly 'eric.leatherman@gmail.com'
        $actual[1] | Should -BeExactly 'shavon.hynd@gmail.com'
        $actual[2] | Should -BeExactly 'essie.genest@gmail.com'
        $actual[3] | Should -BeExactly 'tamara.ridgeon@yahoo.com'
        $actual[4] | Should -BeExactly 'mose.bertsch@yahoo.com'
    }
}
