Import-Module "$PSScriptRoot/../NameIT.psd1"

Describe "NameIT Tests" {

    AfterAll {
        Remove-Item -Recurse -Force "$env:TEMP\TestThePath" -ErrorAction SilentlyContinue
    }

    It "Should generate five entries" {
        $actual = Invoke-Generate -Template "[person]" -Count 5

        $actual.count | Should Be 5
    }

    # It "Should pass in v5 and fail in on all OSes" {
    #     (Get-WmiObject win32_bios) | Should Not Be Null
    # }

    It "Should fail on the path for Linux" {
        $targetPath = "$env:TEMP\TestThePath"
        $null = mkdir $targetPath

        (Test-Path $targetPath) | Should Be $true
    }
}