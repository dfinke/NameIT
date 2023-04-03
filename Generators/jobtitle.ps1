function jobtitle {
    <#
        .SYNOPSIS
        The function is intended to generate a job title
    
        .DESCRIPTION
        The function generates a random job title specific to various departments and levels of experience. The ability to select specific career stages or departments
        is availble, however this is intended primarily for use in supporting other generators.
    
        .PARAMETER CareerLevel
        Enables specification of a specific career stage from which to obtain the job title
    
        .PARAMETER Department
        Enables specification of a specific department to obtain the title for
    
        .NOTES
        KEYWORDS: PowerShell
    
        VERSIONS HISTORY
        0.1.0 - 2023-03-28 - New generator template
    
        .EXAMPLE
        [PS] > Invoke-Generator "[jobtitle]"
        
        Blog Writer
    
        A single job title is returned as plain text.
    
        .EXAMPLE
        [PS] > Invoke-Generator "[jobtitle -CareerLevel Director -Department Diversity]"
        
        Diversity and Inclusion Leader
    
        A single job title is returned as plain text, but results have been limited to options from the Diversity department at the Director career level.

        .EXAMPLE
        [PS] > Invoke-Generator "[jobtitle -AsObject]"
        
        Department          Title                   Level
        ----------          -----                   -----
        Product Management  Product Design Director Director
    
        A single job title is returned as an object that includes the department and career level, in addition to the title.

    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet('Entry','Experienced','Manager','Director','Executive','Chief')]
        [string]$CareerLevel,
        [Parameter()]
        [ValidateSet('Marketing','Communications','Design','Human Resources','Customer Service','Product Management','Warehouse','Diversity','Operations','Administrative','Facilities','Legal','Accounting','Finance','Payroll','Sales','Information Technology','Software Development')]
        [string]$Department,
        [Parameter()]
        [switch]$AsObject,
        [Parameter()]
        [cultureinfo]$Culture = [cultureinfo]::CurrentCulture
    )

    #region DataImport
        ## Note: All data imported from flat files should be placed in this section. While it would reduce line counts to just perform selections
        ## in a single step here, this should be avoided. Always perform selection actions in the InternalGen section for code consistency when possible.

        $deptjobTitles = Resolve-LocalizedPath -Culture $Culture -ContentFile deptjobtitles.csv | Import-CacheableCsv -Delimiter ','

    #endregion DataImport

    #region ExternalGen
        ## Note: Calls to external generators would go here, along with any supplemental processing needed that does not depend on internally generated
        ## data. If supplemental data must exist to apply filters, filtering should occur in InternalGen section.

    #endregion ExternalGen

    #region InternalGen
        ## All code specific to this generator that involves filtering, setting, or creating values, including manipulation of data from any external
        ## generator calls should be placed in this section. For simple generations, where you are just getting a random item from a single data set,
        ## the code for selection goes into the CreatePSObject section.

        if($Department){
            # Statically set the department if specified as input
            $departmentVal = $Department
        }else {
            # Dynamically set the department if not specified as input, by getting unique department names from data set and randomizing
            $departmentVal = ($deptjobTitles).Department | Select-Object -Unique | Get-Random
        }

        # Filter the list of titles by department
        $TitleList = $deptjobTitles.Where({$_.Department -eq $departmentVal})

        if($CareerLevel){
            # Provide specialized titles for specific career level
            $JobTitle = ($TitleList).Where({$_.Level -eq $CareerLevel}) | Get-Random
        }else {
            # Provide a title at a random level if career level isn't specified
            $JobTitle = $TitleList | Get-Random
        }

    #endregion InternalGen

    #region CreatePSObject
        ## Note: Data from external and internal generation processes is converted to a custom object here. For simple selections, where only a single
        ## text value is produced, this section can be skipped. Values may be formatted in this section, but they should not be set here.

        $output = [PSCustomObject]@{
            Department = $departmentVal
            Title = $JobTitle.Title
            Level = $JobTitle.Level
        }
    
    #endregion CreatePSObject

        #region DataSet
        ## Note: This section is for execlusively for defining which properties will be part of the final output being written to the pipeline. This
        ## section is comprised of only two elements. The first is any groupings of properties needed, based on the selected parameter values. The
        ## second is assignment of property sets to a single variable that is used in the Output section. For simple generators with no options, this
        ## section can be skipped.

        # N/A as there are no filters for properties at present

    #endregion DataSet

    #region Output
        ## Note: This section should not be performing any other processing except filtering the properties being sent to the pipeline, formatted as
        ## as either an object or string using the propertyName variable defined in the DataSet section.

        if($AsObject){
            $output 
        }else{
            $output.Title
        }

    #endregion Output
}