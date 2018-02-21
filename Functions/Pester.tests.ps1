Import-Module Pester
Import-Module  PSScriptAnalyzer

$ModuleName = "Graphite-Powershell"
$Author = 'Matthew Hodgkins'
$Description = 'A group of PowerShell functions that allow you to send Windows Performance counters to a Graphite Server, all configurable from a simple XML file.'
$CompanyName = 'https://github.com/MattHodge/Graphite-PowerShell-Functions'

$Path = "$(Split-path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition))"

# Find the Manifest file
$ManifestFile = "$Path\$ModuleName.psd1"

# Import the module and store the information about the module
$ModuleInformation = Import-module -Name "$Path\$ModuleName" -PassThru

# Get the functions present in the Manifest
$ExportedFunctions = $ModuleInformation.ExportedFunctions.Values.name

# Get the functions present in the Public folder
$PS1Functions = Get-ChildItem -path "$Path\Functions\*.ps1"

Describe "$ModuleName Module - Testing Manifest File (.psd1)"{
    Context "Manifest"{
        It "Should contains RootModule"{
            $ModuleInformation.RootModule | Should Contain "$ModuleName.psm1"
        }
        It "Should contains Author"{
            $ModuleInformation.Author | Should Contain $Author 
        }
        It "Should contains Company Name"{
            $ModuleInformation.CompanyName | Should Contain $CompanyName
        }
        It "Should contains Description"{
            $ModuleInformation.Description | Should Contain  $Description
        }
    }
}

Describe "Tests the module framework" {

    It "Is valid PowerShell" {

        $contents = Get-Content -Path "$Path\$ModuleName.psm1" -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It 'passes the PSScriptAnalyzer without Errors' {
        (Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error).Count | Should Be 0
    }
}