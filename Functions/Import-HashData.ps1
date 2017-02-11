#Requires -Version 4.0
function Import-HashData
{
<#
.SYNOPSIS
    Import serialized objects from disk.

.DESCRIPTION
    Import serialized objects from disk. The import will check the content of the file
    for RestrictedLanguage. Only New-Date function is allowed in the script. Other commands
    will result in an error and the import will fail.

.PARAMETER Path
    The target file that contains the Serialized object(s).

.PARAMETER UnsafeMode
    If supplied, no you allow any command to be executed in the runspace when the object is deserialized.

.EXAMPLE
    $objects = Import-Hashdata -Path c:\temp\Hash.txt

    This will deserialize the content/objects in the hash.txt file

.INPUTS
    String

.OUTPUTS  
    hashtable
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding(
    SupportsShouldProcess=$true,
    ConfirmImpact='medium'    
)]
Param (
    [string]
    $Path
    ,
    [switch]
    $UnsafeMode
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    if (-not (Test-Path -Path $Path))
    {
        Write-Error -Message "Unable to find file [$path]" -ErrorAction Stop
    }

    Write-Verbose -Message "$f -  Importing data from [$path]"

    [string]$data = Get-Content -Path $path -Encoding UTF8 -Raw -ReadCount 0

    if ($UnsafeMode.IsPresent)
    {
        #fixme this is a hack
        $PreviousConfirmPreference = $ConfirmPreference
        $ConfirmPreference = "low"
        if ($PScmdlet.ShouldProcess($path, "Unsafe script invokation"))
        {
            $ConfirmPreference = $PreviousConfirmPreference
            Write-Warning -Message "You are importing persisted data without cheching RestrictedLanguage because you supplied the UnSafeMode switch."
            $script = [scriptblock]::Create($data)
            & $script
        }        
    }
    else 
    {
        #fixme this is a hack
        $PreviousConfirmPreference = $ConfirmPreference
        $ConfirmPreference = "high"
        
        if ($PScmdlet.ShouldProcess($path, "Safe script invokation"))
        {            
            $ConfirmPreference = $PreviousConfirmPreference
            Write-Verbose -Message "$f -  Asserting script content"
            Assert-ScriptString -Data $data -ErrorAction Stop            
        }        
    }    

    Write-Verbose -Message "$f - END"
}