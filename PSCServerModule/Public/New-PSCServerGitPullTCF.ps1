Function New-PSCServerGitPullTCF {
    param(
        [Parameter(Mandatory=$true)]
        [string]$RepoName
    )
$content = @"
@{
    TaskAction  = @{
        Execute                         = 'powershell' 
        Argument                        = '-WindowStyle Hidden -File C:\GitHub\PSConfigurationAsCode\ServerScripts\Git-$RepoName-Repo.ps1'
        #Id                              = '1'
        #WorkingDirectory                = 'D:\Manual Scripts'
    }

    TaskTrigger = @{
        Once                            = `$true 
        #Daily                           = `$true
        #Weekly                          = `$true
        #AtStartup                       = `$true
        #AtLogOn                         = `$true
        #DaysOfWeek                      = 'Monday'
        At                              = '2:00'
        RepetitionInterval              = "00.00:10:00"

    }

    TaskPrincipal = @{
        UserId                          = ''
        LogonType                       = 'Password' # Password is equivilent to checking the box "Runn whether user is logged on or not"
        RunLevel                        = 'Limited' # Limited is equivilent to not checking the box "Run with highest privileges".  This is the desired setting for cloning repos.  Cloning as admin can cause permission issues.
    }
    PrincipalSecretName                 = ''

    TaskSettingSet = @{
        AllowStartIfOnBatteries             = `$false            #<bool>
        AsJob                               = `$false            #<bool>
        #CimSession                          = `$null             # <CimSession[]>
        Compatibility                       = 'Win7'            #{At | V1 | Vista | Win7 | Win8}
        #DeleteExpiredTaskAfter              = "00.00:00:00"     #<timespan>
        Disable                             = `$false            #<bool>
        DisallowDemandStart                 = `$false            #<bool>
        DisallowHardTerminate               = `$false            #<bool>
        DisallowStartOnRemoteAppSession     = `$false            #<bool>
        DontStopIfGoingOnBatteries          = `$false            #<bool>
        DontStopOnIdleEnd                   = `$false            #<bool>
        ExecutionTimeLimit                  = "03.00:00:00"     #<timespan>
        Hidden                              = `$false            #<bool>
        IdleDuration                        = "00.00:10:00"     #<timespan>
        IdleWaitTimeout                     = "00.01:00:00"     #<timespan>
        #MaintenanceDeadline                 = "00.00:00:00"     #<timespan>
        #MaintenanceExclusive                = `$false            #<bool>
        #MaintenancePeriod                   = "00.00:00:00"     #<timespan>
        MultipleInstances                   = "IgnoreNew"       #{Parallel | Queue | IgnoreNew}
        #NetworkId                           = ""                #<string>
        #NetworkName                         = ""                #<string>
        Priority                            = 7                 #<int>
        RestartCount                        = 0                 #<int>
        #RestartInterval                     = "00.00:00:00"     #<timespan>
        RestartOnIdle                       = `$false            #<bool>
        RunOnlyIfIdle                       = `$false            #<bool>
        RunOnlyIfNetworkAvailable           = `$false            #<bool>
        StartWhenAvailable                  = `$false            #<bool>    
        WakeToRun                           = `$false            #<bool>
    }

    TaskName    = 'Github - Pull $RepoName'
    TaskPath    = "\Github Core\"
    Description = "Clones the $RepoName Repo"

}
"@

Write-Output $content

}