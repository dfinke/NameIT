$module = Resolve-Path  "$PSScriptRoot/../NameIt.psd1"

Import-Module $module

Describe "NameIT Tests" {
    It "Should generate five entries" {
        $actual = Invoke-Generate "[person]" -Count 5

        $actual.count | Should Be 5
    }
}