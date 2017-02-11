#Requires -Version 4.0
function ConvertTo-HashString
{
<#
.SYNOPSIS
    Convert an hashtable or and OrderedDictionary to a string

.DESCRIPTION
    Convert an hashtable or and OrderedDictionary to a string

.PARAMETER InputObject
    The object that is to be converted

.EXAMPLE
    $hashObject = @{
        Name = "Tore"
        Goal = "Rule the World"
    }
    $hashObject | ConvertTo-HashString

    This will convert the hashtable to the following string
    @{Name = "Tore";Goal = "Rule the World";}

.INPUTS
    Hashtable

.OUTPUTS
    string
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param (
    [Parameter(ValueFromPipeLine)]
    $InputObject
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process
{
    $out = "@{"

    if (-not $InputObject -or $InputObject.keys.count -eq 0) {return "@{}"}

    foreach ($key in $InputObject.Keys)
    {
        Write-Verbose -Message "$f -  Processing key [$key]"

        if ($key.Contains('$'))
        {
            $DisplayKey = "'$key'"
        }

        $value = $InputObject.$key
        $objType = $value.GetType().Name
        Write-Verbose -Message "$f -  ObjectType = $objType"
        
        $mode = "stringValue"

        if ($objType -eq "Hashtable" -or $objType -eq "OrderedDictionary")
        {
            $mode = "hashtable"
        }
        
        if ($value -is [array])
        {
            if ($value[0])
            {
                $arrayType = $value[0].GetType().Name
                Write-Verbose -Message "$f -  arrayType is [$arrayType]"
                
                if ($arrayType -eq "Hashtable" -or $arrayType -eq "OrderedDictionary")
                {
                    $mode = "HashTableValue"
                }
                else
                {
                    $mode = "ArrayValue"
                }
            }            
        }
        
        Write-Verbose -Message "$f -  Mode is [$mode]"
        if ($DisplayKey)
        {
            $key = $DisplayKey
            $DisplayKey = $null
        }

        $out += "$key = "
        
        switch ($mode)
        {
            'stringValue' 
            {
                if ($value -is [int] -or $value -is [double])
                {
                    $out += "$value;"
                }
                elseif ($value -is [bool]) {
                    $out += '$' + "$value;"
                }
                elseif ($value -is [datetime]) {
                    $ticks = $value.Ticks
                    $out += "New-Date $ticks;"
                }
                else 
                {
                    $out += '"' + $value + '";'
                }                
            }

            'hashtable'
            {               
                $stringValue = ConvertTo-HashString -InputObject $value
                $out += $stringValue + ";"
            }

            'HashTableValue'
            {
                $stringValue = ""
                foreach ($arrayHash in $value)
                {                                       
                    $hashString = ConvertTo-HashString -InputObject $arrayHash
                    $hash = "$hashString"
                    $hash = "$hash,"
                    $stringValue += $hash
                }
                $separatorIndex = $stringValue.LastIndexOf(",")
                $stringValue = $stringValue.Remove($separatorIndex,1)                
                $out += $stringValue + ";"
            }

            'ArrayValue'
            {
                if ($value[0] -is [int] -or $value[0] -is [double])
                {
                    $out += ($value -join ",") + ";"
                }
                else 
                {
                    $out += '"' +($value -join '","') + '";'
                }
                
            }
            
            default 
            {
                Write-Error -Message "Invalid mode in funtion $f"
            }
        }
    }   
    $out += "}"
    $out          
}

End 
{
    Write-Verbose -Message "$f - End"
}
}


