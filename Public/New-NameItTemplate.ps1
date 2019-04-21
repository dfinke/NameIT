function New-NameItTemplate {
    <#
        .SYNOPSIS
        Auto gen a template
    
        .EXAMPLE
        ig (New-NameItTemplate {[PSCustomObject]@{Company="";Name="";Age=0;address="";state="";zip=""}}) -Count 5 -AsPSObject | ft
    #>
        param(
            [scriptblock]$sb
        )
    
        $result = &$sb
        $result.psobject.properties.name.foreach( {
                $propertyName = $_
    
                switch ($propertyName) {
                    "name"    {"$($propertyName)=[person]"}
                    "zip"     {"$($propertyName)=[state zip]"}
                    "address" {"$($propertyName)=[address]"}
                    "state"   {"$($propertyName)=[state]"}
                    default   {
                        $dataType = Invoke-AllTests $result.$propertyName -OnlyPassing -FirstOne
                        "{0}=[{1}]" -f $propertyName, (Convert-DataTypeToNameIt $dataType.dataType)
                    }
                }
            }) -join "`r`n"
    }
    