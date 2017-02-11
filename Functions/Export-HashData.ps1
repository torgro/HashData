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
    The target file that will store the serialized object

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
    ConfirmImpact='High'    
)]
Param (
    [string]
    $Path
    ,
    [Parameter(ValueFromPipeline)]
    $InputObject
    ,
    [switch]
    $Append
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}
    
Process 
{    
    $fileContent = ""

    Write-Verbose -Message "$f -  Converting inputobject to string"
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

    
    if ($Append.IsPresent)
    {        
        if ($PSCmdlet.ShouldProcess("$Path", "$f - Append to file"))
        {        
            Write-Verbose -Message "$f -  Appending to file [$Path]"
            Add-Content @file
        }        
    }
    else
    {       
        if ($PSCmdlet.ShouldProcess("$Path", "$f - Overwriting file"))
        {            
            Write-Verbose -Message "$f -  Writing to file [$Path]"
            Set-Content @file
        }              
    }
}

End 
{
    Write-Verbose -Message "$f - END"
}
}