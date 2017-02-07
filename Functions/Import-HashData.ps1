function Import-HashData
{
[cmdletbinding()]
Param(
    [string]
    $Path
    ,
    [switch]
    $UnsafeMode
)
    if (-not (Test-Path -Path $Path))
    {
        Write-Error -Message "Unable to find file [$path]" -ErrorAction Stop
    }

    $data = Get-Content -Path $path -Encoding UTF8 -Raw -ReadCount 0
    if ($UnsafeMode.IsPresent)
    {
        $script = [scriptblock]::Create($data)
        & $script
    }
    else 
    {
        Import-PersistedData -Data $data -ErrorAction Stop
    }    
}