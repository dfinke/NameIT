Import-Module "$PSScriptRoot/../NameIT.psd1"

Describe "NameIT Tests" {

    BeforeAll {
        $script:targetPath = "$env:TEMP/TestThePath"
    }

    AfterAll {
        Remove-Item -Recurse -Force $script:targetPath -ErrorAction SilentlyContinue
    }

    It "Should generate five entries" {
        $actual = Invoke-Generate -Template "[person]" -Count 5

        $actual.count | Should Be 5
    }

    # It "Should pass in v5 and fail in on all OSes" {
    #     (Get-WmiObject win32_bios) | Should Not Be Null
    # }

    It "Should fail on the path for Linux" {
        $null = mkdir $script:targetPath

        (Test-Path $script:targetPath) | Should Be $true
    }
}