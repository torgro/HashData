#Requires -Version 4.0
function Assert-ScriptString
{
<#
.SYNOPSIS
    Validate a scriptblock before execution into current runspace

.DESCRIPTION
    Validate a string before execution into current runspace. The only allowed allowed 
    command/cmdlet is New-Date included in this module. The string is converted to a scriptblock 
    and is only executed if the validation passes.

.PARAMETER Data
    The string that is to be validated for restricted language.

.EXAMPLE
    $string = @"
    @{
            Name = "Tore"
            Goal = "Rule the World"
        }
    "@
    $scriptOutput = Assert-ScriptString -Data $string

.INPUTS
    String

.OUTPUTS
    
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param (
    [Parameter(ValueFromPipeline)]
    [string]
    $Data
)
    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
    try
    {
        $script = [scriptblock]::Create($data)
        [string[]]$allowedCommands = @("New-Date")
        [string[]]$allowedVariables = @()
        
        $script.CheckRestrictedLanguage($allowedCommands, $allowedVariables, $false)

        & $script
    }
    catch
    {
        if ($previousErrorAction -ne "SilentlyContinue")
        {
            Write-Error -Exception $_.Exception -ErrorAction Stop
        }        
    }
    Finally
    {
        $ErrorActionPreference = $previousErrorAction
    }
}