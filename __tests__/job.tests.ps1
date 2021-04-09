Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Job Generation Test" {

    BeforeEach {
        $null = Get-Random -SetSeed 1        
    }

    It "Tests returning a job title" {
        $actual = Invoke-Generate '[job]' -Count 5

        $actual[0] | Should -BeExactly 'Science teacher'
        $actual[1] | Should -BeExactly 'Scrum master'
        $actual[2] | Should -BeExactly 'Retail sales associate'
        $actual[3] | Should -BeExactly 'Dentist'
        $actual[4] | Should -BeExactly 'International human resources associate'
    }
}