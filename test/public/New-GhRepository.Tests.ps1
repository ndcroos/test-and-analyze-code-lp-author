BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    . "$PSScriptRoot/../../source/private/Invoke-Gh.ps1"; mock Invoke-Gh {};
}

Describe "New-GhRepository" -Tag "Unit" {

    Context "Parameters" {

	# 1. Function should have a mandatory parameter Name of type string
	# 2. Function should have optional parameters [string] Description and [bool] Private
        it "Has parameters" {
            $function = Get-Command "New-GhRepository"  
            $function | Should -HaveParameter Name -Mandatory -Type string
            $function | Should -HaveParameter Description -Type string
            $function | Should -HaveParameter Homepage -Type string
            $function | Should -HaveParameter Private -Type boolean
            $function | Should -HaveParameter HasIssues -Type boolean
            $function | Should -HaveParameter HasProjects -Type boolean
            $function | Should -HaveParameter HasWiki -Type boolean
            $function | Should -HaveParameter HasDiscussions -Type boolean
            $function | Should -HaveParameter TeamId -Type int
            $function | Should -HaveParameter AutoInit -Type boolean
            $function | Should -HaveParameter GitignoreTemplate -Type string
            $function | Should -HaveParameter LicenseTemplate -Type string
            $function | Should -HaveParameter AllowSquashMerge -Type boolean
            $function | Should -HaveParameter AllowMergeCommit -Type boolean
            $function | Should -HaveParameter AllowRebaseMerge -Type boolean
            $function | Should -HaveParameter AllowAutoMerge -Type boolean
            $function | Should -HaveParameter DeleteBranchOnMerge -Type boolean
            $function | Should -HaveParameter SquashMergeCommitTitle -Type string      
            $function | Should -HaveParameter SquashMergeCommitMessage -Type string
            $function | Should -HaveParameter MergeCommitTitle -Type string
            $function | Should -HaveParameter MergeCommitMessage -Type string
            $function | Should -HaveParameter HasDownloads -Type boolean
            $function | Should -HaveParameter IsTemplate -Type boolean
        }
    }

    Context "Run" {
	# 3. When making API call, URL should contain user/repos part in it, and be of method Post. 
	# The body of the call needs to include a key “Name” with a value of $Name. 
	# Variables can be dynamically resolved; the test needs to ensure the right URL is being called.
        it "Sends correct endpoint" {
            New-GhRepository -Name test1
            Should -Invoke "Invoke-GH" -ParameterFilter {$Endpoint -eq "user/repos" -AND $Method -eq "Post" -AND $Body["Name"] -eq "test1"}
        }

        it "Transforms parameters from PowerShell to GitHub" {
            New-GhRepository -Name test2 -Private $true -GitignoreTemplate template2
            Should -Invoke "Invoke-GH" -ParameterFilter {
                $Endpoint -eq "user/repos" -AND 
                $Method -eq "Post" -AND
                $Body["Name"] -eq "test2" -AND
                $body["Private"] -eq "true" -AND
                $body["gitignore_template"] -eq "template2"}
        }
    }
}