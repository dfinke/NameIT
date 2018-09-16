Import-Module "$PSScriptRoot/../NameIT.psd1"


Describe "NameIT Tests" {

    It "Should generate five entries" {
        $actual = Invoke-Generate -Template "[person]" -Count 5
        $actual.count | Should Be 5
    }

    # It "Should pass all versions all OSes" {
    #     (Get-WmiObject win32_bios) | Should Not Be Null
    # }

    # It "Should pass all versions all OSes" {
    #     (Get-CimInstance win32_bios) | Should Not Be Null
    # }

    It "Should fail on Linux" {
        "" | Set-Content "$PSScriptRoot\Test.txt"
        (Test-Path "$PSScriptRoot\test.txt") | Should Be $true
    }

    # It "Should pass on Linux - correct case" {
    #     "" | Set-Content "$PSScriptRoot\test.txt"
    #     (Test-Path "$PSScriptRoot\test.txt") | Should Be $true
    # }
}