#Requires -Version 4.0
function New-Date
{
[cmdletbinding()]
Param (
    [Parameter(Position=0)]
    [int64]
    $Ticks
)
[datetime]$Ticks
}