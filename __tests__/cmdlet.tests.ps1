﻿Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "Cmdlet Generation Test (en culture)" -Tag Cmdlet {

    BeforeEach {
        # Get-Random generates different numbers for PS 5.1 or PS 7*. Values based on 7's implementation.
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
                
        $actual[0] | Should -BeExactly 'Skip-Question'
        $actual[1] | Should -BeExactly 'Submit-Library'
        $actual[2] | Should -BeExactly 'Search-Primary'
        $actual[3] | Should -BeExactly 'Wait-Guy'
        $actual[4] | Should -BeExactly 'Undo-Suggestion'
    }
}
Describe "Cmdlet Generation Test (sv culture)" -Tag Cmdlet, CultureSv {

    BeforeEach {
        # Get-Random generates different numbers for PS 5.1 or PS 7*. Values based on 7's implementation.
        $null = Get-Random -SetSeed 1        
    }

    It "Generates a cmdlet-like name" {
        $actual = Invoke-Generate '[cmdlet]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Placerar-Brev'
        $actual[1] | Should -BeExactly 'Överraskar-Arbetsplats'
        $actual[2] | Should -BeExactly 'Vänjer-Make'
        $actual[3] | Should -BeExactly 'Klipper-Fjärrkontroll'
        $actual[4] | Should -BeExactly 'Dör-Förmiddag'
    }
    It "Generates a cmdlet-like name with an approved verb" {
        $actual = Invoke-Generate '[cmdlet approved]' -Count 5 -Culture sv

        $actual.Count | Should -Be 5
                
        $actual[0] | Should -BeExactly 'Skip-Kapitel'
        $actual[1] | Should -BeExactly 'Invoke-Fotboll'
        $actual[2] | Should -BeExactly 'Search-Banan'
        $actual[3] | Should -BeExactly 'Clear-Tulpan'
        $actual[4] | Should -BeExactly 'Deny-Päron'
    }
}