param(
    [ValidateScript({$_ -Match '^[a-zA-Z0-9_-]+$'})]
    [string]$GitRepoName = 'ImportantProductionAutomations',
    [ValidateScript({$_ -Match '^[a-zA-Z0-9_-]+$'})]
    [string]$GitRepoOwner = 'TheRealZero',
    [ValidateScript({$_ -Match '^[a-zA-Z0-9_-]+$'})]
    [Parameter(HelpMessage = 'The name of the containing directory where the repo will be/is cloned')]
    [string]$GitRepoDirPath = "$env:PSCWorkloadRepoPath",
    [Parameter(HelpMessage = 'The output directory path for the log file')]
    [string]$LogDirectory = "$(Resolve-Path -Path "$env:PSCLogOutputPath\GitPull")"
)

$scriptName = $myInvocation.MyCommand.Name
$logName    = $scriptName -replace '\.ps1', '.log'
$GitRepoDirectory = Join-Path $GitRepoDirPath $GitRepoName

Start-Transcript -Path $(Join-Path $LogDirectory $logName) -Append

if(Test-Path -Path $GitRepoDirectory){
    Set-Location $GitRepoDirectory
    Write-Host "Path exists, fetching..."
    
    $expressions = @(
        "git fetch --all",
        "git reset --hard origin/main",
        "git clean -fd"
    )
    Try{
        Foreach ( $exp in $expressions ) {
            Write-Host "$exp"
            Invoke-Expression -Command $exp
            Write-Host "...done."
        }
   }
   Catch{
       Write-Warning "Error while fetching repository from upstream: $_"
       Exit 401
    }
}

else{
    Set-Location $env:PSCWorkloadRepoPath

    Write-Host "Path doesn't exist, cloning..."
    $expression = "git clone git@github.com:$GitRepoOwner/$GitRepoName.git"
    Try{
        Invoke-Expression -Command $expression
        Write-Host "...done."

    }
    Catch{
        Write-Warning "Error while cloning repository: $_"
        Exit 400
    }
}



Stop-Transcript

