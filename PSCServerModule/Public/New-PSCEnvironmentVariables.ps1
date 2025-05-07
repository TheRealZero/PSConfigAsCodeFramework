Function New-PSCEnvironmentVariables {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "The name of the Automation account to use.")]
        [string]$PSCDefaultAccount = "PSCAutomation",
        [Parameter(Mandatory = $false, HelpMessage = "The path to the cloned PSC repository")]
        [string]$PSCRepoPath = "$(Resolve-Path -Path $PSScriptRoot\..)",
        [Parameter(Mandatory = $false, HelpMessage = "The path to the directory where automation workload repos are stored")]
        [string]$PSCWorkloadRepoPath = "$env:systemdrive\git",
        [Parameter(Mandatory = $true, HelpMessage = "The name of the default owner account for workload GitHub repositories")]
        [string]$PSCDefaultOwner,
        [Parameter(Mandatory = $true, HelpMessage = "The path to the directory where logs are stored")]
        [string]$PSCLogOutputPath
    )

    # Check if the PSC repo path exists
    If (-not (Test-Path -Path $PSCRepoPath)) {
        Write-Error "The specified PSC repo path does not exist: $PSCRepoPath" -ErrorAction Stop
    }
    $PSCRepoPath            = ((Resolve-path -Path $PSCRepoPath)            -split "\\" |Where-Object {[string]::IsNullOrEmpty($_) -ne $true}) -Join "\"
    $PSCWorkloadRepoPath    = ((Resolve-path -Path $PSCWorkloadRepoPath)    -split "\\" |Where-Object {[string]::IsNullOrEmpty($_) -ne $true}) -Join "\"
    $PSCLogOutputPath       = ((Resolve-path -Path $PSCLogOutputPath)       -split "\\" |Where-Object {[string]::IsNullOrEmpty($_) -ne $true}) -Join "\"
    
    $verboseOutputMessage = "PSCDefaultAccount: $PSCDefaultAccount `n`tPSCRepoPath: $PSCRepoPath `n`tPSCWorkloadRepoPath: $PSCWorkloadRepoPath `n`tPSCDefaultOwner: $PSCDefaultOwner `n`tPSCLogOutputPath: $PSCLogOutputPath"

    # Create the PSC environment variables
    Try {
        If ($PSCmdlet.ShouldProcess("Create environment variables.`n`t$verboseOutputMessage", "This will create the following environment variables:`n`t$verboseOutputMessage","Creating PSC environment variables")) {
            [System.Environment]::SetEnvironmentVariable("PSCDefaultAccount",   $PSCDefaultAccount,     [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCRepoPath",         $PSCRepoPath,           [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCWorkloadRepoPath", $PSCWorkloadRepoPath,   [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCDefaultOwner",     $PSCDefaultOwner,       [System.EnvironmentVariableTarget]::Machine)
            [System.Environment]::SetEnvironmentVariable("PSCLogOutputPath",    $PSCLogOutputPath,      [System.EnvironmentVariableTarget]::Machine)
            Write-Verbose "Environment variables created successfully."
        }
    }
    Catch {
        Write-Error "Failed to set environment variables: $_" -ErrorAction Stop
    }
}