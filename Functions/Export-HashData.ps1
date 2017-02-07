function Export-HashData
{
[cmdletbinding()]
Param(
    [string]
    $Path
    ,
    $InputObject
    ,
    [switch]
    $Append
)
    #FixMe Implement shouldprocess
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
    
    if ($Append.IsPresent)
    {
        Add-Content @file
    }
    else
    {
        Set-Content @file
    }
}