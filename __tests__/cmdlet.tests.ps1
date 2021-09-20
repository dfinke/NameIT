Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Cmdlet Generation Test" -Tag Cmdlet {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Generates a cmdlet-like name" {
        $actual = Invoke-Generate '[cmdlet]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Pace-Panic'
        $actual[1] | Should -BeExactly 'Bus-Model'
        $actual[2] | Should -BeExactly 'Line-Principle'
        $actual[3] | Should -BeExactly 'Skin-Gear'
        $actual[4] | Should -BeExactly 'Kid-Top'
    }
    It "Generates a cmdlet-like name with an approved verb" {
        $actual = Invoke-Generate '[cmdlet approved]' -Count 5 -Culture en

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Skip-Quit'
        $actual[1] | Should -BeExactly 'Send-Lift'
        $actual[2] | Should -BeExactly 'Set-Prior'
        $actual[3] | Should -BeExactly 'Use-Hang'
        $actual[4] | Should -BeExactly 'ConvertTo-Sweet'
    }
}
Describe "Cmdlet Generation Test (sv culture)" -Tag Cmdlet, CultureSv {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Generates a cmdlet-like name" {
        $actual = Invoke-Generate '[cmdlet]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Placerar-Ide'
        $actual[1] | Should -BeExactly 'Tål-Gran'
        $actual[2] | Should -BeExactly 'Dukar-Ide'
        $actual[3] | Should -BeExactly 'Anar-Tall'
        $actual[4] | Should -BeExactly 'Sjuder-Tall'
    }
    It "Generates a cmdlet-like name with an approved verb" {
        $actual = Invoke-Generate '[cmdlet approved]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Skip-Ide'
        $actual[1] | Should -BeExactly 'Receive-Ide'
        $actual[2] | Should -BeExactly 'Compress-Mo'
        $actual[3] | Should -BeExactly 'Export-Mo'
        $actual[4] | Should -BeExactly 'Write-Tall'
    }
}