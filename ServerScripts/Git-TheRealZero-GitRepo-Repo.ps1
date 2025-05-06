param(
    [ValidateScript({$_ -Match '^[a-zA-Z0-9_-]+$'})]
    [string]$GitRepoName = "GitRepo",
    [string]$LogDirectory = "$env:LogOutputPath\GitPull"
)

$scriptName = $myInvocation.MyCommand.Name
$logName    = $scriptName -replace '\.ps1', '.log'
$GitRepoDirectory = Join-Path $env:GitRepos $GitRepoName

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
    Set-Location $env:GitRepos

    Write-Host "Path doesn't exist, cloning..."
    $expression = "git clone git@github.com:TheRealZero/$GitRepoName.git"
    Try{
        Invoke-Expression -Command $expression
        Write-Host "...done."

    }
    Catch{
        Write-Warning "Error while cloneing repository: $_"
        Exit 400
    }
}



Stop-Transcript
