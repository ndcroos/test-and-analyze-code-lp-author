BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    . "$PSScriptRoot/../../source/private/Invoke-Gh.ps1"; mock Invoke-Gh {};
}

Describe "Get-GhRepository" -Tag "Unit" {

    Context "Parameters" {

	# Function should have mandatory parameters: Owner and Repo, of type string
        it "Has parameters" {
            $function = Get-Command "Get-GhRepository"  
            $function | Should -HaveParameter Owner -Mandatory -Type String
            $function | Should -HaveParameter Repo -Mandatory -Type String
        }
    }

    Context "Run" {

	# When making API call, URL should contain repos/$owner/$repo part in it, 
	# and be of method Get. 
	# Variables can be dynamically resolved; 
	# the test needs to ensure the right URL is being called.
        it "Sends correct endpoint" {
            Get-GhRepository -Owner owner1 -Repo repo1
            Should -Invoke "Invoke-GH" -ParameterFilter { $Endpoint -eq "repos/owner1/repo1" -AND $Method -eq "Get" }
        }

    }
}