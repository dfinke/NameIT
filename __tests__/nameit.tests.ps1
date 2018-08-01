Import-Module $module "$PSScriptRoot/../NameIT.psd1"

Describe "NameIT Tests" {
    It "Should generate five entries" {
        $actual = Invoke-Generate -Template "[person]" -Count 5

        $actual.count | Should Be 5
    }
}