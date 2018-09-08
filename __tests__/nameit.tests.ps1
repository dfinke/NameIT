Import-Module "$PSScriptRoot/../NameIT.psd1"

Describe "NameIT Tests" {
    It "Should generate five entries" {
        $actual = Invoke-Generate -Template "[person]" -Count 5

        $actual.count | Should Be 5
    }

    It "Should pass in v5 and fail in on all OSes" {
        (Get-WmiObject win32_bios) | Should Not Be Null
    }
}