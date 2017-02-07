function Import-PersistedData
{
[cmdletbinding()]
Param(
    [string]$Data
)
    try
    {
        $script = [scriptblock]::Create($data)
        [string[]]$allowedCommands = @("New-Date")
        [string[]]$allowedVariables = @()
        
        $script.CheckRestrictedLanguage($allowedCommands, $allowedVariables,$false)
        & $script
    }
    catch
    {
        Write-Error -Exception $_.Exception -ErrorAction Stop
    }
}