#Requires -Version 4.0
function Export-HashData
{
<#
.SYNOPSIS
    Serialize an object to a file as an HashTable.

.DESCRIPTION
    Serialize an object to a file as an HashTable. The majority of the types of the object
    is preserved in the output. To handle datetime, the module have a function New-Date that
    only can create a date from a long tick value.

.PARAMETER Path
    The target file that will store the Specialized object

.PARAMETER InputObject
    The object that should be Serialized.

.PARAMETER Append
    Append the Serialized object to the file.

.EXAMPLE
    $obj = [pscustomobject]@{
        Name = "Tore"
        Age = 45
        CodeCoverage = 11.21
        Date = (Get-Date)
        IntArray = 1,2,3
    }

    Export-HashData -Path C:\Temp\hash.txt -InputObject $obj

    This will serialize the $obj variable and save this string in the file hash.txt
    @{Name = "Tore";Age = 45;CodeCoverage = 11.21;Date = New-Date 636221857704582734;IntArray = 1,2,3;}

.INPUTS

.OUTPUTS  
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding(
     SupportsShouldProcess=$true,
    ConfirmImpact='Medium'
)]
Param(
    [string]
    $Path
    ,
    [Parameter(ValueFromPipeline)]
    $InputObject
    ,
    [switch]
    $Append
    ,
    [switch]
    $Force
)
    if ($Append.IsPresent)
    {
        if (-not (Test-Path -Path $Path))
        {
            Set-Content -Path $Path -Value $null -Encoding UTF8
        }
    }

    $fileContent = ""

    if ($InputObject -is [hashtable] -or $InputObject -is  [System.Collections.Specialized.OrderedDictionary])
    {
        $fileContent = $InputObject | ConvertTo-HashString
    }
    else 
    {
        foreach ($input in $InputObject)
        {
            $fileContent += $input | ConvertTo-Hashtable | ConvertTo-HashString
        }    
    }

    $file = @{
        Path = $Path
        Value = $fileContent
        Encoding = "UTF8"
    }

    $shouldProcessOperation = "Creating file"
    if ($Force.IsPresent)
    {
        $file.Add("Force", $true)
        $shouldProcessOperation = "Overwriting file"
    }

    if ($Append.IsPresent)
    {
        if ($PSCmdlet.ShouldProcess("$Path", "Append to file"))
        {
            if (-not (Test-Path -Path $Path))
            {
                Set-Content -Path $Path -Value $null -Encoding UTF8
            }        
            Add-Content @file
        }        
    }
    else
    {
        if ($PSCmdlet.ShouldProcess("$Path", "$shouldProcessOperation"))
        {            
            Set-Content @file
        }              
    }
}