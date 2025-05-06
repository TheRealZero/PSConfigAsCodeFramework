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
Function New-PSCServerScheduledTask {
    <#
    .SYNOPSIS
    Creates a new scheduled task on a server
    .DESCRIPTION
    This script creates a new scheduled task on a server using the parameters in a config file
    .PARAMETER ConfigFilePath
    The path to the config file containing the parameters for the scheduled task
    .EXAMPLE
    New-PSCServerScheduledTask -ConfigFilePath "C:\Scripts\TaskConfig.psd1"
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Parameter(Mandatory = $true, HelpMessage = "The path to the config file containing the parameters for the scheduled task")]
        [string]$ConfigFilePath
    )
    
    
    Try {
        Test-Path $ConfigFilePath -ErrorAction Stop | Out-Null
    }
    Catch {
        Write-Error "Config file not found at $ConfigFilePath"
    }

    Try {
        Import-PowerShellDataFile -Path $ConfigFilePath -OutVariable taskconfig -ErrorAction STOP | Out-Null
        Write-Information "Imported config file: $($ConfigFilePath)" -Verbose
    }
    Catch {
        Write-Information "Error importing config file" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop

    }

    Try {
           
        $taskAction = $taskConfig.TaskAction
        $objTaskAction = New-ScheduledTaskAction @taskAction -ErrorAction STOP
        
        $taskTrigger = $taskConfig.TaskTrigger
        $objTaskTrigger = New-ScheduledTaskTrigger @tasktrigger -ErrorAction STOP
        
        $taskPrincipal = $taskConfig.TaskPrincipal
        $objTaskPrincipal = New-ScheduledTaskPrincipal @taskPrincipal -ErrorAction STOP
        
        $taskTask = @{
            Description = $taskConfig.Description
            Action      = $objTaskAction
            Principal   = $objTaskPrincipal
            Trigger     = $objTaskTrigger
        }
        If ( $null -ne $taskConfig.TaskSettingSet ) {
            $taskSettingSet = $taskConfig.TaskSettingSet
            $objTaskSettingSet = New-ScheduledTaskSettingsSet @taskSettingSet -ErrorAction STOP
            $taskTask.Add("Settings", $objTaskSettingSet)
        }
        
        If ( $taskConfig.PrincipalSecretName ) {
            Try {
                $principalCredential = Get-Secret -Name $taskConfig.PrincipalSecretName -ErrorAction STOP
            }
            Catch {
                Write-Information "Error getting principal secret: $($TaskConfig.PrincipalSecretName)" -Verbose
                Write-Error $_.Exception.Message -Verbose -ErrorAction Stop

            }
        }

        
        $objTask = New-ScheduledTask @taskTask -ErrorAction STOP

        $registerTaskParams = @{
            TaskName    = $taskConfig.TaskName
            TaskPath    = $taskConfig.TaskPath
            InputObject = $objTask

        }

        If ( $taskConfig.taskprincipal.LogonType -in @("InteractiveOrPassword", "Password")) {
            $registerTaskParams.Add("User", $taskPrincipal.UserId)
            $registerTaskParams.Add("Password", $($principalCredential.GetNetworkCredential().Password))
        }
    }
    Catch {
        Write-Information "Error creating task parameters" -Verbose
        Write-Information $_.Exception.Message -Verbose
    }

    Write-Information "Registering Task: $($registerTaskParams.TaskName)." -Verbose
    $safeTaskParams = $registerTaskParams | Select-Object -ExcludeProperty Password
    Write-Verbose "$($safeTaskParams | Out-String)"
    Try {
        If ( $PSCmdlet.ShouldProcess("Registering a new scheduled task $($safeTaskParams | Out-String)", "$($registerTaskParams.TaskName)", "Registering scheduled task")) {
            Register-ScheduledTask @registerTaskParams -Verbose:$false -ErrorAction Stop
        }
    }
    Catch {
        Write-Information "Error registering task: $($registerTaskParams.TaskName)." -Verbose
        Write-Information $_.Exception.Message -Verbose
    }
    Finally {
        #lucas look into where this should go!
        Remove-Variable -Name registerTaskParams -ErrorAction SilentlyContinue
    }
}
Function Update-PSCServerScheduledTask {
    <#
    .SYNOPSIS
    Creates a new scheduled task on a server
    .DESCRIPTION
    This script creates a new scheduled task on a server using the parameters in a config file
    .PARAMETER ConfigFilePath
    The path to the config file containing the parameters for the scheduled task
    .EXAMPLE
    New-PSCServerScheduledTask -ConfigFilePath "C:\Scripts\TaskConfig.psd1"
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Parameter(Mandatory = $true, HelpMessage = "The path to the config file containing the parameters for the scheduled task")]
        [string]$ConfigFilePath
    )
    
    
    Try {
        Test-Path $ConfigFilePath -ErrorAction Stop | Out-Null
    }
    Catch {
        Write-Error "Config file not found at $ConfigFilePath" -ErrorAction Stop
    }

    Try {
        Import-PowerShellDataFile -Path $ConfigFilePath -OutVariable taskconfig -ErrorAction STOP | Out-Null
        Write-Information "Imported config file: $($ConfigFilePath)" -Verbose
    }
    Catch {
        Write-Information "Error importing config file" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop
        
    }

    Try {
           
        $taskAction = $taskConfig.TaskAction
        $objTaskAction = New-ScheduledTaskAction @taskAction -ErrorAction STOP
        
        $taskTrigger = $taskConfig.TaskTrigger
        $objTaskTrigger = New-ScheduledTaskTrigger @tasktrigger -ErrorAction STOP
        
        $taskPrincipal = $taskConfig.TaskPrincipal
        $objTaskPrincipal = New-ScheduledTaskPrincipal @taskPrincipal -ErrorAction STOP
        
        $taskTask = @{
            Action    = $objTaskAction
            Principal = $objTaskPrincipal
            Trigger   = $objTaskTrigger
        }

        If ( $null -ne $taskConfig.TaskSettingSet ) {
            $taskSettingSet = $taskConfig.TaskSettingSet
            $objTaskSettingSet = New-ScheduledTaskSettingsSet @taskSettingSet -ErrorAction STOP
            $taskTask.Add("Settings", $objTaskSettingSet)
        }

        If ( $taskConfig.PrincipalSecretName ) {
            Try {
                $principalCredential = Get-Secret -Name $taskConfig.PrincipalSecretName -ErrorAction STOP
            }
            Catch {
                Write-Information "Error getting principal secret: $($TaskConfig.PrincipalSecretName)" -Verbose
                Write-Error $_.Exception.Message -Verbose -ErrorAction Stop

            }
        }

             
        $setTaskParams = @{
            TaskName = $taskConfig.TaskName
            TaskPath = $taskConfig.TaskPath    
        }
        Foreach ( $key in $taskTask.Keys) {
            $setTaskParams.Add($key, $taskTask[$key])  
        }

        If ( $taskConfig.taskprincipal.LogonType -in @("InteractiveOrPassword", "Password")) {
            $setTaskParams.Add("User", $taskPrincipal.UserId)
            $setTaskParams.Add("Password", $($principalCredential.GetNetworkCredential().Password))
            $setTaskParams.Remove("Principal")
        }
    }
    Catch {
        Write-Information "Error creating task parameters" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop
        
    }

    Write-Information "Updating Task: $($setTaskParams.TaskName)." -Verbose
    $safeTaskParams = $setTaskParams | Select-Object -ExcludeProperty Password

    
    Try {
        If ( $PSCmdlet.ShouldProcess("Updating an existing scheduled task $($safeTaskParams | Out-String)", "$($setTaskParams.TaskName)", "Updating an existing scheduled task")) {
            Set-ScheduledTask @setTaskParams -Verbose:$false
        }
    }
    Catch {
        Write-Information "Error updating task" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop
        
    }
    Finally {
        #lucas look into where this should go!
        Remove-Variable -Name setTaskParams -ErrorAction SilentlyContinue
    }

}
