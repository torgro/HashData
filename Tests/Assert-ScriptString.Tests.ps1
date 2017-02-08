
$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath hashdata.psd1
Import-Module $modulePath
                                      
#cd C:\Users\tore\Dropbox\SourceTreeRepros\HashData ; import-module .\HashData.psd1

Describe "Assert-ScriptString" {
    $asserted = "@{Test=1;date=new-date 636221878124518548}"
    $assertedObj = [scriptblock]::Create($asserted).invoke()

    Context "Validate output" {
        $actual = Assert-ScriptString -Data $asserted

        It "Should output an object" {
            $actual | Should Not Be $null
        }

        It "Should produce a hashtable" {
            $actual.GetType().Name | Should Be "Hashtable"
        }
 
        It "Should have a key [Test]" {
            $actual.ContainsKey("Test") | should be $true
        }

        It "Should have a key [Test] with value [$($assertedObj.Test)]" {
            $actual.Test | Should be $assertedObj.Test
        }

        It "Should be of type [$($assertedObj.Test.GetType().Name)]" {
            $actual.Test.GetType().Name | Should be $assertedObj.Test.GetType().Name
        }

        It "Should have a key [date]" {
            $actual.ContainsKey("Date") | Should be $true
        }

        It "Should have a key [Test] with value [$($assertedObj.Date.Ticks)]" {
            $actual.Date.Ticks | Should be $assertedObj.Date.Ticks
        }

        It "Should be of type [$($assertedObj.GetType().Name)]" {
            $actual.Date.GetType().Name | Should be $assertedObj.Date.GetType().Name
        }
    }
    
    Context "Test for restricted language" {
        $asserted = "@{Test=1;date=write-verbose 636221878124518548}"

        It "Should throw if string contains unapproved cmdlets" {
            { $asserted | Assert-ScriptString } | Should throw
        }

        It "Should not execute the scrip text if it contains unapproved cmdlets" {
            "Write-output 1" | Assert-ScriptString -ErrorAction SilentlyContinue | Should be $null
        }
    }
}

Remove-Module hashdata -ErrorAction SilentlyContinue