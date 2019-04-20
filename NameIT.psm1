$Script:ModuleBase = $PSScriptRoot

. $ModuleBase\InferData.ps1  # TODO: figure out if this is still needed/used by anything

$Subs = @(
    @{
        Path = 'Classes'
        Export = $false
        Recurse = $false
        Filter = '*.Class.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } ,

    @{
        Path = 'Private'
        Export = $false
        Recurse = $true
        Filter = '*-*.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } ,

    @{
        Path = 'Public'
        Export = $true
        Recurse = $false
        Filter = '*-*.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } ,

    @{
        Path = 'Generators'
        Export = $false
        Recurse = $false
        Filter = '*.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } 
) 


$thisModule = [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
($varName = "__${thisModule}_Export_All") | Write-Verbose -Verbose
$exportAll = Get-Variable -Scope Global -Name $varName -ValueOnly -ErrorAction Ignore

$Subs | ForEach-Object -Process {
    $sub = $_
    $thisDir = $ModuleBase | Join-Path -ChildPath $sub.Path | Join-Path -ChildPath '*'
    $thisDir | 
    Get-ChildItem -Filter $sub.Filter -Exclude $sub.Exclude -Recurse:$sub.Recurse -ErrorAction Ignore | ForEach-Object -Process {
        try {
            $Unit = $_.FullName
            Write-Verbose -Message "Importing '$Unit'" -Verbose
            . $Unit
            if ($sub.Export -or $exportAll) {
                Export-ModuleMember -Function $_.BaseName
            }
        } catch {
            $e = "Could not import '$Unit' with exception: `n`n`n$($_.Exception)" -as $_.Exception.GetType()
            throw $e
        }
    }
}


Set-Alias ig Invoke-Generate
Export-ModuleMember -Alias 'ig'