Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Job Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a job title" {
        $actual = Invoke-Generate '[job]' -Count 5

        $actual[0] | Should -BeExactly 'Superintendent'
        $actual[1] | Should -BeExactly 'Tutor'
        $actual[2] | Should -BeExactly 'Veterinary assistant'
        $actual[3] | Should -BeExactly 'English teacher'
        $actual[4] | Should -BeExactly 'Software developer'
    }
}