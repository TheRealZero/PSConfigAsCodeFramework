Function New-PSCEnvironmentVariables {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "The name of the Automation account to use.")]
        [string]$PSCDefaultAccount = "PSCAutomation",
        [Parameter(Mandatory = $false, HelpMessage = "The path to the cloned PSC repository")]
        [string]$PSCRepoPath = "$(Resolve-Path -Path $PSScriptRoot\..)",
        [Parameter(Mandatory = $false, HelpMessage = "The path to the directory where automation workload repos are stored")]
        [string]$PSCWorkloadRepoPath = "$env:systemdrive\git"
    )

    # Check if the PSC repo path exists
    if (-not (Test-Path -Path $PSCRepoPath)) {
        Write-Error "The specified PSC repo path does not exist: $PSCRepoPath" -ErrorAction Stop
    }
    $PSCRepoPath = ((Resolve-path -Path $PSCRepoPath) -split "\\" |Where-Object {[string]::IsNullOrEmpty($_) -ne $true}) -Join "\"
    Write-Verbose "Creating PSC environment variables..."
    Write-Verbose "PSCDefaultAccount: $PSCDefaultAccount"
    Write-Verbose "PSCRepoPath: $PSCRepoPath"

    # Create the PSC environment variables
    Try {
        If ($PSCmdlet.ShouldProcess("Create environment variables.`n  PSCDefaultAccount: $PSCDefaultAccount `n  PSCRepoPath: $PSCRepoPath", "This will create the following environment variables:`n  PSCDefaultAccount: $PSCDefaultAccount `n  PSCRepoPath: $PSCRepoPath","Creating PSC environment variables")) {
            [System.Environment]::SetEnvironmentVariable("PSCDefaultAccount", $PSCDefaultAccount, [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCRepoPath", $PSCRepoPath, [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCWorkloadRepoPath", $PSCWorkloadRepoPath, [System.EnvironmentVariableTarget]::Machine)
            Write-Verbose "Environment variables created successfully."
        }
    }
    Catch {
        Write-Error "Failed to set environment variables: $_" -ErrorAction Stop
    }
}