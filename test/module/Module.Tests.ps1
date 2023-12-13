BeforeAll {
    # Import the GitHub module; this should be the module that has just been built
    Import-Module -Name "$PSScriptRoot/../../build/Rct.GitHub/Rct.GitHub.psd1"
}

Describe "Rct.GitHub" -Tag "Integration" {
    Context "Repository lifecycle" {
        it "Creates, updates and removes a repository" {
	    # Authenticate to GitHub
            Connect-RctGh -Token ($Env:GHTOKEN | ConvertTo-SecureString -Force -AsPlainText)
	    # Generate a new name for the repo, e.g., a random GUID
            $newRepository = New-Guid
            Write-Host "New Repository: [$newRepository]"
	    # Test if the repo with such a name doesn’t exist
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Throw
	    # Create repo
            New-RctGhRepository -Private $true -Name $newRepository -AutoInit $true
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Not -Throw
	    # Update, e.g., description in the repo
            Set-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository -Description "This is a test"
	    # Retrieve the repo once again, and confirm the description actually got updated
            $repo = Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository
            $repo.Description | Should -Be "This is a test"
	    # Delete the repo
            { Remove-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Not -Throw
	    # Confirm the repository doesn’t exist
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Throw
        }
    } 
}