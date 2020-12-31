# $manifestPath = $PSScriptRoot | Join-Path -ChildPath '..' | Join-Path -ChildPath 'NameIT.psd1' | Resolve-Path
Import-Module  "$PSScriptRoot\..\NameIT.psd1" -Force

Describe "NameIT Tests" {
    BeforeAll {
        $map = @{
            1 = 1, 2, 3
            2 = 4, 5, 6
            3 = 7, 8, 9
            4 = 10, 11, 12
        }
    }
    
    Context "Date tests" {
        It "Test Month of January" {
            $actual = Invoke-Generate '[January]' 
            (Get-Date $actual).Month | Should -Be 1
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of February" {
            $actual = Invoke-Generate '[February]' 
            (Get-Date $actual).Month | Should -Be 2
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of March" {
            $actual = Invoke-Generate '[March]' 
            (Get-Date $actual).Month | Should -Be 3
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of April" {
            $actual = Invoke-Generate '[April]' 
            (Get-Date $actual).Month | Should -Be 4
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of May" {
            $actual = Invoke-Generate '[May]' 
            (Get-Date $actual).Month | Should -Be 5
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of June" {
            $actual = Invoke-Generate '[June]' 
            (Get-Date $actual).Month | Should -Be 6
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of July" {
            $actual = Invoke-Generate '[July]' 
            (Get-Date $actual).Month | Should -Be 7
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of August" {
            $actual = Invoke-Generate '[August]' 
            (Get-Date $actual).Month | Should -Be 8
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of September" {
            $actual = Invoke-Generate '[September]' 
            (Get-Date $actual).Month | Should -Be 9
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of October" {
            $actual = Invoke-Generate '[October]' 
            (Get-Date $actual).Month | Should -Be 10
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of November" {
            $actual = Invoke-Generate '[November]' 
            (Get-Date $actual).Month | Should -Be 11
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test Month of 12" {
            $actual = Invoke-Generate '[December]' 
            (Get-Date $actual).Month | Should -Be 12
            (Get-Date $actual).Year | Should -Be (Get-Date).Year
        }

        It "Test ThisYear" {
            $actual = Invoke-Generate '[ThisYear]' 
            $actual | Should -Be (Get-Date).Year
        }

        It "Test ThisMonth" {
            $actual = Invoke-Generate '[ThisMonth]' 
            $actual | Should -Be (Get-Date).Month
        }

        It "Test Today" {
            $actual = Invoke-Generate '[Today]' 
            $actual | Should -Be (Get-Date).ToShortDateString()
        }

        It "Test Tomorrow" {
            $actual = Invoke-Generate '[Tomorrow]' 
            $actual | Should -Be (Get-Date).AddDays(1).ToShortDateString()
        }

        It "Test Yesterday" {
            $actual = Invoke-Generate '[Yesterday]' 
            $actual | Should -Be (Get-Date).AddDays(-1).ToShortDateString()
        }

        It "Test ThisQuarter" {
            $actual = Invoke-Generate '[ThisQuarter]' 
            
            $month = (Get-Date).Month
            [int]$qtr = [math]::Floor(($month + 2) / 3)

            (Get-Date $actual).Month | Should -BeIn $map.$qtr
        }

        It "Test ThisWeek" {
            Get-Date -UFormat %V | Should -Be (Invoke-Generate [ThisWeek])
        }

        It "Test LastYear" {
            Invoke-Generate '[LastYear]' | Should -Be (Get-Date).AddYears(-1).ToShortDateString()
        }

        It "Test NextYear" {
            Invoke-Generate '[NextYear]' | Should -Be (Get-Date).AddYears(-1).ToShortDateString() 
        }

        It "Test LastMonth" {
            Invoke-Generate '[LastMonth]' | Should -Be (Get-Date).AddMonths(-1).ToShortDateString()
        }

        It "Test NextMonth" {
            Invoke-Generate '[NextMonth]' | Should -Be (Get-Date).AddMonths(-1).ToShortDateString()
        }

        It "Test Q1" {
            $actual = Invoke-Generate '[Q1]' 
            
            $actualQtr = [math]::Floor(((get-date $actual).Month + 2) / 3)
            $actualQtr | Should -Be 1
        }

        It "Test Q2" {
            $actual = Invoke-Generate '[Q2]' 
            
            $actualQtr = [math]::Floor(((get-date $actual).Month + 2) / 3)
            $actualQtr | Should -Be 2
        }
        
        It "Test Q3" {
            $actual = Invoke-Generate '[Q3]' 
            
            $actualQtr = [math]::Floor(((get-date $actual).Month + 2) / 3)
            $actualQtr | Should -Be 3
        }
        
        It "Test Q4" {
            $actual = Invoke-Generate '[Q4]' 
            
            $actualQtr = [math]::Floor(((get-date $actual).Month + 2) / 3)
            $actualQtr | Should -Be 4
        }
    }
}