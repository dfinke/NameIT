# $module = Resolve-Path  "$PSScriptRoot/../NameIt.psd1"
# Import-Module $module
# Import-Module $PSScriptRoot/../NameIt

Import-Module $module "$PSScriptRoot/../NameIT.ps1"

Describe "NameIT Tests" {
    It "Should generate five entries" {
        $actual = Invoke-Generate "[person]" -Count 5

        $actual.count | Should Be 5
    }
}