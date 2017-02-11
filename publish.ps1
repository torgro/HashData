[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [string]
    $APIkey
)

$tags = @(
    "hashtable"
    , 
    "serialize"
    , 
    "deserialize"
    , 
    "pscustomobject"
    , 
    "import"
    ,
    "export"
    ,
    "convert"
    ,
    "Convertto"
    ,
    "String"
) 


Publish-Module -NuGetApiKey $APIkey -Name .\poshdata.psd1