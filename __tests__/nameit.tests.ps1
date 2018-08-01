Import-Module $PSScriptRoot/../NameIt.psd1

Describe "NameIT Tests" {
    It "Should generate five entries" {
        $actual = Invoke-Generate "[person]" -Count 5

        $actual.count | Should Be 5
    }
}